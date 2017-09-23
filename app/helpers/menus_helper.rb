module MenusHelper
  def menu_json(menu)
    establishment   = menu.establishment
    account         = establishment.account
    preview_path    = account_establishment_menu_preview_path(account, establishment, format: :pdf)
    available_lists = establishment.lists - menu.lists
    lists = menu.menu_lists.includes(:list).map do |ml|
      {
        menu_list_id: ml.id,
        show_price_on_menu: ml.show_price_on_menu
      }.merge(ml.list.attributes)
    end
    menu.as_json.merge({
      lists: lists.as_json,
      listsAvailable: available_lists.as_json,
      previewPath: preview_path
    }).to_json
  end

  def menu_font_options
    Menu::FONTS
  end

  def menu_template_options
    Menu::TEMPLATES
  end
end
