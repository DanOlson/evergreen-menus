class MenuCenteredPdf
  include ActionView::Helpers::NumberHelper
  include Prawn::View
  TIME_FORMAT = '%l:%M %P'

  attr_reader :menu, :lists

  def initialize(menu:, lists: nil)
    @menu  = menu
    @lists = lists || default_lists
  end

  def filename
    @filename ||= begin
      menu_name = @menu.name.split(/[[:space:]]/).map(&:downcase).join('-')
      "#{menu_name}-#{Time.now.to_i}.pdf"
    end
  end

  def generate
    font menu.font

    header
    body

    draw_border
  end

  def render
    generate

    super
  end

  private

  def draw_border
    repeat(:all) do
      move_to bounds.top_left
      stroke_color 'cecece'

      middle_y = Float(bounds.height) / 2
      middle_x = Float(bounds.width) / 2
      curve_offset = 30

      stroke do
        ###
        # Top
        curve_to [middle_x, bounds.top], bounds: [
          [middle_x / 3, bounds.top - curve_offset],
          [(middle_x / 3) * 2, bounds.top + curve_offset]
        ]
        curve_to bounds.top_right, bounds: [
          [bounds.width - (middle_x / 3 * 2), bounds.top + curve_offset],
          [bounds.width - middle_x / 3, bounds.top - curve_offset]
        ]

        ###
        # Right
        curve_to [bounds.width, middle_y], bounds: [
          [bounds.width - curve_offset, bounds.height - middle_y / 3],
          [bounds.width + curve_offset, bounds.height - middle_y / 3 * 2]
        ]
        curve_to [bounds.bottom_right], bounds: [
          [bounds.width + curve_offset, middle_y / 3 * 2],
          [bounds.width - curve_offset, middle_y / 3]
        ]

        ###
        # Bottom
        curve_to [middle_x, bounds.bottom], bounds: [
          [bounds.width - middle_x / 3, bounds.bottom + curve_offset],
          [bounds.width - middle_x / 3 * 2, bounds.bottom - curve_offset]
        ]
        curve_to bounds.bottom_left, bounds: [
          [middle_x / 3 * 2, bounds.bottom - curve_offset],
          [middle_x / 3, bounds.bottom + curve_offset]
        ]

        ###
        # Left
        curve_to [bounds.left, middle_y], bounds: [
          [bounds.left + curve_offset, middle_y / 3],
          [bounds.left - curve_offset, middle_y / 3 * 2]
        ]
        curve_to bounds.top_left, bounds: [
          [bounds.left - curve_offset, bounds.height - middle_y / 3 * 2],
          [bounds.left + curve_offset, bounds.height - middle_y / 3]
        ]
      end
    end
  end

  def default_lists
    menu.menu_lists.joins(:list).select('lists.*, menu_lists.show_price_on_menu')
  end

  def header
    bounding_box([bounds.left, cursor], width: bounds.width, height: 50) do
      pad_top(10) do
        text menu.name.upcase, {
          align: :center,
          style: :bold,
          size: menu.font_size * 1.25
        }

        if menu.restricted_availability?
          start_time = menu.availability_start_time.strftime(TIME_FORMAT)
          end_time = menu.availability_end_time.strftime(TIME_FORMAT)
          text "Available #{start_time} - #{end_time}", {
            align: :center,
            size: menu.font_size
          }
        end
      end
    end
  end

  def body
    bounding_box([bounds.left, cursor], width: bounds.width, height: bounds.height) do
      lists.each do |list|
        render_list list: list
        move_down 10
      end
    end
  end

  def render_list(list:)
    if cursor < 200
      # We're close enough to the bottom to start a new column/page
      start_new_page
      return render_list list: list
    end
    list_heading list: list

    beers = Beer.where(list: list).order(:name)
    beers.each do |beer|
      menu_item beer, show_price: list.show_price_on_menu?
    end
  end

  def list_heading(list:)
    font_size = menu.font_size + 2
    pad_bottom(15) do
      text "<u>#{list.name.upcase}</u>", {
        size: font_size,
        color: 'c7254e',
        style: :bold,
        align: :center,
        inline_format: true
      }
    end
  end

  def menu_item(beer, show_price:)
    font_size = menu.font_size
    fragments = [
      {
        text: beer.name + "\n",
        size: font_size,
        styles: [:bold]
      }
    ]

    if beer.description
      fragments << {
        text: beer.description + "\n",
        size: font_size,
        styles: [:italic]
      }
    end

    if show_price && beer.price
      precision = (beer.price % 1).zero? ? 0 : 1
      fragments << {
        text: number_with_precision(beer.price, precision: precision, significant: false),
        size: font_size
      }
    end

    menu_item_box = Prawn::Text::Formatted::Box.new(fragments, {
      at: [bounds.left, cursor],
      width: bounds.width,
      align: :center,
      document: document
    })

    # dry run the render to pre-calculate the height of the box
    menu_item_box.render(dry_run: true)
    descent_amount = menu_item_box.height + 10
    if y - descent_amount < bounds.bottom + 50
      start_new_page
      return menu_item beer, show_price: show_price
    end
    menu_item_box.render
    move_down descent_amount
  end
end
