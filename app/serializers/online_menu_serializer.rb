class OnlineMenuSerializer
  include Rails.application.routes.url_helpers

  def initialize(online_menu)
    @online_menu = online_menu
  end

  def call
    @online_menu.as_json.merge({
      lists: lists.as_json,
      listsAvailable: available_lists,
      previewPath: preview_path,
    }).to_json
  end

  private

  def establishment
    @establishment ||= @online_menu.establishment
  end

  def lists
    @online_menu.online_menu_lists.includes(list: :beers).map do |ml|
      list = ListSerializer.new(ml.list).call(as_json: true, include_items: true)
      {
        online_menu_list_id: ml.id,
        show_price_on_menu: ml.show_price_on_menu,
        show_description_on_menu: ml.show_description_on_menu,
        items_with_images: Array(ml.list_item_metadata['items_with_images']).map(&:to_i)
      }.merge(list)
    end
  end

  def available_lists
    available = establishment.lists.includes(:beers) - @online_menu.lists.includes(:beers)
    available.map { |list| ListSerializer.new(list).call(as_json: true) }
  end

  def preview_path
    account_establishment_online_menu_preview_path(
      establishment.account,
      establishment
    )
  end
end
