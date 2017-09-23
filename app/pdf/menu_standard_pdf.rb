class MenuStandardPdf
  include ActionView::Helpers::NumberHelper
  include Prawn::View

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
    # footer
  end

  def render
    generate

    super
  end

  private

  def default_lists
    menu.menu_lists.joins(:list).select('lists.*, menu_lists.show_price_on_menu')
  end

  def header
    bounding_box([0, cursor], width: bounds.width, height: 50) do
      text menu.name.upcase, {
        align: :center,
        style: :bold,
        size: menu.font_size * 1.25
      }
    end
  end

  def footer
    bottom_left = [bounds.left, bounds.bottom]
    bounding_box(bottom_left, width: bounds.width, height: 10) do
      text = "Page <page> - Updated #{@menu.updated_at.strftime('%m/%d')}"
      number_pages text, {
        size: [menu.font_size, 10].min,
        align: :center
      }
    end
  end

  def body
    column_opts = {
      columns: menu.number_of_columns,
      width: bounds.width,
      height: margin_box.height,
      spacer: 12,
      reflow_margins: true
    }
    column_box([bounds.left, cursor], column_opts) do
      lists.each do |list|
        render_list list: list
        move_down 10
      end
    end
  end

  def render_list(list:)
    if cursor < 200
      # We're close enough to the bottom to start a new column/page
      bounds.move_past_bottom
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
      text list.name.upcase, {
        size: font_size,
        style: :bold
      }
      dash 1, space: 2
      stroke_horizontal_line bounds.left, bounds.right
    end
  end

  def menu_item(beer, show_price:)
    font_size = menu.font_size
    current_y_pos = cursor

    fragments = [
      {
        text: beer.name,
        styles: [:bold],
        size: font_size
      },
      {
        text: "\n",
        size: font_size,
      },
      {
        text: beer.description,
        size: font_size - 2,
      }
    ]
    name_box_width_multiplier = show_price ?  0.6 : 1
    name_box = Prawn::Text::Formatted::Box.new(fragments, {
      at: [bounds.left, current_y_pos],
      width: bounds.width * name_box_width_multiplier,
      align: :left,
      document: document
    })

    # dry run the render to pre-calculate the height of the box
    name_box.render(dry_run: true)
    descent_amount = name_box.height + 5
    if y - descent_amount < bounds.bottom
      bounds.move_past_bottom
      return menu_item beer, show_price: show_price
    end
    name_box.render

    if beer.price && show_price
      text_box number_to_currency(beer.price), {
        at: [bounds.left, current_y_pos],
        size: font_size,
        style: :bold,
        align: :right
      }
    end

    move_down descent_amount
  end
end
