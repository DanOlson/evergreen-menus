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
    pdf.text menu.name, align: :center, size: 18
  end

  def footer(pdf)
    bottom_left = [pdf.bounds.left, pdf.bounds.bottom]
    pdf.bounding_box(bottom_left, width: pdf.bounds.width, height: 10) do
      text = "Page <page> - Updated #{@menu.updated_at.strftime('%m/%d')}"
      pdf.number_pages text, {
        size: 10,
        align: :center
      }
    end
  end

  def body(pdf)
    lists.each do |list|
      render_list list: list, pdf: pdf
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
    pdf.pad(20) { pdf.text "<u>#{list.name}</u>", size: 14, inline_format: true }
  end

  def menu_item(beer, pdf:, show_price:)
    pdf.float do
      pdf.text beer.name
    end

    if show_price
      pdf.float do
        pdf.text number_to_currency(beer.price), align: :right
      end
    end

    pdf.move_down 13
  end
end
