class MenuBasicPdf
  include ActionView::Helpers::NumberHelper

  attr_reader :menu, :lists

  def initialize(menu:, lists: nil)
    @menu  = menu
    @lists = lists || default_lists
  end

  def filename
    @filename ||= "tmp/menu-basic-#{Time.now.to_i}.pdf"
  end

  def generate
    pdf = Prawn::Document.new

    pdf.font menu.font

    header pdf
    body pdf
    footer pdf

    pdf
  end

  def render
    pdf = generate

    pdf.render
  end

  private

  def default_lists
    menu.menu_lists.joins(:list).select('lists.*, menu_lists.show_price_on_menu')
  end

  def header(pdf)
    pdf.bounding_box([0, pdf.cursor], width: pdf.bounds.width) do
      pdf.text menu.name, align: :center, size: menu.font_size + 2
    end
  end

  def footer(pdf)
    bottom_left = [pdf.bounds.left, pdf.bounds.bottom]
    pdf.bounding_box(bottom_left, width: pdf.bounds.width, height: 10) do
      text = "Page <page> - Updated #{@menu.updated_at.strftime('%m/%d')}"
      pdf.number_pages text, {
        size: [menu.font_size, 10].min,
        align: :center
      }
    end
  end

  def body(pdf)
    column_opts = {
      columns: menu.number_of_columns,
      width: pdf.bounds.width,
      spacer: 12,
      reflow_margins: false
    }
    pdf.bounding_box([0, pdf.cursor], width: pdf.bounds.width) do
      pdf.column_box([0, pdf.cursor], column_opts) do
        lists.each do |list|
          render_list list: list, pdf: pdf
        end
      end
    end
  end

  def render_list(list:, pdf:)
    list_heading list: list, pdf: pdf

    beers = Beer.where(list: list)

    beers.each do |beer|
      menu_item beer, pdf: pdf, show_price: list.show_price_on_menu?
    end
  end

  def list_heading(list:, pdf:)
    font_size = menu.font_size + 2
    pdf.pad(20) { pdf.text "<u>#{list.name}</u>", size: font_size, inline_format: true }
  end

  def menu_item(beer, pdf:, show_price:)
    font_size = menu.font_size

    if show_price
      pdf.float do
        pdf.text number_to_currency(beer.price), size: font_size, align: :right
      end
    end
    pdf.float do
      pdf.text beer.name, size: font_size
    end

    pdf.text "\n"
  end
end
