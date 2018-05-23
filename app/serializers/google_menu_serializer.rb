class GoogleMenuSerializer
  include Rails.application.routes.url_helpers

  def initialize(google_menu)
    @google_menu = google_menu
  end

  def call
    @google_menu.as_json.merge({
      lists: lists.as_json,
      listsAvailable: available_lists,
      previewPath: preview_path,
    }).to_json
  end

  private

  def establishment
    @establishment ||= @google_menu.establishment
  end

  def lists
    @google_menu.google_menu_lists.includes(list: :beers).map do |ml|
      list = ListSerializer.new(ml.list).call(as_json: true)
      {
        google_menu_list_id: ml.id,
        show_price_on_menu: ml.show_price_on_menu,
        show_description_on_menu: ml.show_description_on_menu
      }.merge(list)
    end
  end

  def available_lists
    available = establishment.lists.includes(:beers) - @google_menu.lists.includes(:beers)
    available.map { |list| ListSerializer.new(list).call(as_json: true) }
  end

  def preview_path
    account_establishment_google_menu_preview_path(
      establishment.account,
      establishment
    )
  end
end
