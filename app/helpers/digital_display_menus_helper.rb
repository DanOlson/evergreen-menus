module DigitalDisplayMenusHelper
  ROTATION_INTERVALS = [
    { value: 5000, name: '5 seconds' },
    { value: 10000, name: '10 seconds' },
    { value: 15000, name: '15 seconds' },
    { value: 30000, name: '30 seconds' },
    { value: 60000, name: '1 minute' },
    { value: 120000, name: '2 minutes' },
    { value: 300000, name: '5 minutes' },
    { value: 600000, name: '10 minutes' }
  ]

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
      previewPath: preview_path,
      isHorizontal: digital_display_menu.horizontal_orientation,
      rotationInterval: digital_display_menu.rotation_interval || ROTATION_INTERVALS.first[:value],
      backgroundColor: digital_display_menu.background_color,
      textColor: digital_display_menu.text_color,
      listTitleColor: digital_display_menu.list_title_color
    }).to_json
  end

  def rotation_intervals_json
    ROTATION_INTERVALS.to_json
  end
end
