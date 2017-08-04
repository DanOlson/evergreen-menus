class MenuBasicPdf
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
    footer
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
    bounding_box([0, cursor], width: bounds.width) do
      text menu.name, align: :center, size: menu.font_size + 2
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
      spacer: 12,
      reflow_margins: true
    }
    column_box([bounds.left, cursor], column_opts) do
      lists.each do |list|
        render_list list: list
      end
    end
  end

  def render_list(list:)
    list_heading list: list

    beers = Beer.where(list: list)

    beers.each do |beer|
      menu_item beer, show_price: list.show_price_on_menu?
    end
  end

  def list_heading(list:)
    font_size = menu.font_size + 2
    pad(20) { text "<u>#{list.name}</u>", size: font_size, inline_format: true }
  end

  def menu_item(beer, show_price:)
    font_size = menu.font_size
    current_y_pos = cursor

    text_box beer.name, {
      at: [bounds.left, current_y_pos],
      size: font_size,
      align: :left
    }

    if show_price
      text_box number_to_currency(beer.price), {
        at: [bounds.left, current_y_pos],
        size: font_size,
        align: :right
      }
    end

    text "\n" # Required to lower the cursor y position
  end
end
