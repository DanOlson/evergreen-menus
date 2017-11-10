class WebMenuSerializer
  def initialize(web_menu)
    @web_menu = web_menu
  end

  def call
    @web_menu.as_json.merge({
      lists: lists.as_json,
      listsAvailable: available_lists.as_json
    }).to_json
  end

  private

  def establishment
    @establishment ||= @web_menu.establishment
  end

  def lists
    @web_menu.web_menu_lists.includes(list: :beers).map do |ml|
      {
        web_menu_list_id: ml.id,
        show_price_on_menu: ml.show_price_on_menu
      }.merge(ml.list.as_json)
    end
  end

  def available_lists
    establishment.lists.includes(:beers) - @web_menu.lists.includes(:beers)
  end
end
