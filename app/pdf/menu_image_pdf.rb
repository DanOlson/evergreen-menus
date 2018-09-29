class MenuImagePdf < PdfTemplate
  def generate
    font_families.update(
      "glyphter" => {
        normal: "#{Rails.root}/app/assets/fonts/Glyphter.ttf"
      }
    )
    font menu.font

    header
    body
  end

  private

  def header
    establishment_logo menu
    bounding_box([0, cursor], width: bounds.width, height: 50) do
      text menu.name.upcase, {
        align: :center,
        style: :bold,
        size: menu.font_size * 1.25
      }

      if menu.restricted_availability?
        availability_range = AvailabilityRange.call menu
        text "Available #{availability_range}", {
          align: :center,
          size: menu.font_size
        }
      end
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

    beers = Beer.where(list: list).order(:position)
    items_with_images = Array(list.list_item_metadata['items_with_images']).map &:to_i
    beers.each do |item|
      show_image = items_with_images.include?(item.id)
      menu_item item, show_price: list.show_price_on_menu?, show_image: show_image
    end
  end

  def list_heading(list:)
    font_size = menu.font_size + 2
    pad_bottom(15) do
      text list.name.upcase, {
        size: font_size,
        color: 'c7254e',
        style: :bold
      }
      dash 1, space: 2
      stroke_horizontal_line bounds.left, bounds.right
    end
  end

  def menu_item(beer, show_price:, show_image:)
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
        size: font_size - 2
      },
      *Array(beer.labels).map { |label|
        {
          text: " #{label.glyph}",
          size: font_size - 2,
          font: 'glyphter'
        }
      }
    ].reject { |f| f.nil? || f[:text].nil? }
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
    if y - descent_amount < bounds.bottom + 20
      bounds.move_past_bottom
      return menu_item beer, show_price: show_price, show_image: show_image
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

    if show_image && beer.image.attached?
      if bounds.width + 50 > y
        bounds.move_past_bottom
      end
      image_url = url_for beer.image.variant(interlace: 'None')
      image open(image_url), fit: [bounds.width, bounds.width]
      move_down 10
    end
  end
end
