class MenuSerializer
  include Rails.application.routes.url_helpers
  TIME_FORMAT = '%I:%M %p'

  def initialize(menu)
    @menu = menu
  end

  def call
    @menu.as_json.merge({
      lists: lists.as_json,
      listsAvailable: available_lists,
      previewPath: preview_path,
      fontSize: @menu.font_size,
      numberOfColumns: @menu.number_of_columns,
      availabilityStartTime: availability_start,
      availabilityEndTime: availability_end,
      restrictedAvailability: @menu.restricted_availability?,
      hasLogo: @menu.establishment.logo.attached?,
      showLogo: @menu.show_logo
    }).to_json
  end

  private

  def availability_start
    restriction = @menu.availability_start_time and restriction.strftime(TIME_FORMAT)
  end

  def availability_end
    restriction = @menu.availability_end_time and restriction.strftime(TIME_FORMAT)
  end

  def establishment
    @establishment ||= @menu.establishment
  end

  def preview_path
    account_establishment_menu_preview_path(
      establishment.account,
      establishment,
      format: :pdf
    )
  end

  def lists
    @menu.menu_lists.includes(list: { beers: { image_attachment: :blob } }).map do |ml|
      list = ListSerializer.new(ml.list).call(as_json: true, include_items: true)
      {
        menu_list_id: ml.id,
        show_price_on_menu: ml.show_price_on_menu,
        items_with_images: Array(ml.list_item_metadata['items_with_images']).map(&:to_i)
      }.merge(list)
    end
  end

  def available_lists
    available = establishment.lists.includes(beers: { image_attachment: :blob }) - @menu.lists.includes(:beers)
    available.map { |list| ListSerializer.new(list).call(as_json: true, include_items: true) }
  end
end
