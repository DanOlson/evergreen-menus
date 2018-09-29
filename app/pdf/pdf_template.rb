require 'open-uri'

class PdfTemplate
  include Rails.application.routes.url_helpers
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
    raise NotImplementedError
  end

  def render
    generate

    super
  end

  private

  def default_lists
    menu.menu_lists.joins(:list).select('lists.*, menu_lists.show_price_on_menu, menu_lists.list_item_metadata')
  end

  def establishment_logo(menu)
    if menu.show_logo?
      logo_url = url_for menu.establishment.logo
      image open(logo_url), position: :center, height: 120
    end
  end
end