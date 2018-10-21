class MenuBasicPdf < PdfTemplate
  def generate
    font menu.font

    header
    body
    footer

    draw_border
  end

  private

  def draw_border
    repeat(:all) do
      exp_left = bounds.left - 10
      exp_top = bounds.top + 10

      move_to [exp_left, exp_top]
      stroke_color 'cecece'

      stroke do
        rounded_rectangle [exp_left, exp_top], bounds.width + 20, bounds.height + 20, 10
      end
    end
  end

  def header
    bounding_box([0, cursor], width: bounds.width) do
      establishment_logo menu
      text menu.name, align: :center, size: menu.font_size + 2

      if menu.restricted_availability?
        availability_range = AvailabilityRange.call menu
        text "Available #{availability_range}", {
          align: :center,
          size: menu.font_size
        }
      end
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

    beers = Beer.where(list: list).order(:position)

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

    if show_price && beer.price
      text_box formatted_price(beer), {
        at: [bounds.left, current_y_pos],
        size: font_size,
        align: :right
      }
    end

    text "\n" # Required to lower the cursor y position
  end
end
