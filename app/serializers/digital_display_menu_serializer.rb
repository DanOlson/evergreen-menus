require 'delegate'

class DigitalDisplayMenuSerializer
  extend Forwardable
  include Rails.application.routes.url_helpers

  def_delegators :@digital_display_menu,
                 :horizontal_orientation,
                 :rotation_interval,
                 :background_color,
                 :text_color,
                 :list_title_color,
                 :theme

  def initialize(digital_display_menu)
    @digital_display_menu = digital_display_menu
  end

  def call
    @digital_display_menu.as_json.merge({
      lists: lists.as_json,
      listsAvailable: available_lists.as_json,
      previewPath: preview_path,
      isHorizontal: horizontal_orientation,
      rotationInterval: rotation_interval,
      backgroundColor: background_color,
      textColor: text_color,
      listTitleColor: list_title_color,
      theme: theme.name
    }).to_json
  end

  private

  def establishment
    @establishment ||= @digital_display_menu.establishment
  end

  def preview_path
    account_establishment_digital_display_menu_preview_path(
      establishment.account,
      establishment
    )
  end

  def lists
    @digital_display_menu.digital_display_menu_lists
                         .includes(list: :beers)
                         .map do |ml|
      {
        digital_display_menu_list_id: ml.id,
        show_price_on_menu: ml.show_price_on_menu
      }.merge(ml.list.as_json)
    end
  end

  def available_lists
    establishment.lists.includes(:beers) - @digital_display_menu.lists.includes(:beers)
  end
end
