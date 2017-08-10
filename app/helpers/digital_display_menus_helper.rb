module DigitalDisplayMenusHelper
  def digital_display_menu_json(digital_display_menu)
    establishment   = digital_display_menu.establishment
    account         = establishment.account
    available_lists = establishment.lists - digital_display_menu.lists
    preview_path    = account_establishment_digital_display_menu_preview_path(account, establishment)
    lists = digital_display_menu.digital_display_menu_lists.includes(:list).map do |ml|
      {
        digital_display_menu_list_id: ml.id,
        show_price_on_menu: ml.show_price_on_menu
      }.merge(ml.list.attributes)
    end
    digital_display_menu.as_json.merge({
      lists: lists.as_json,
      listsAvailable: available_lists.as_json,
      previewPath: preview_path
    }).to_json
  end
end
