class MenuSerializer
  include Rails.application.routes.url_helpers
  TIME_FORMAT = '%I:%M %p'

  def initialize(menu)
    @menu = menu
  end

  def call
    @menu.as_json.merge({
      lists: lists.as_json,
      listsAvailable: available_lists.as_json,
      previewPath: preview_path,
      fontSize: @menu.font_size,
      numberOfColumns: @menu.number_of_columns,
      availabilityStartTime: availability_start,
      availabilityEndTime: availability_end,
      restrictedAvailability: @menu.restricted_availability?
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
    @menu.menu_lists.includes(list: :beers).map do |ml|
      {
        menu_list_id: ml.id,
        show_price_on_menu: ml.show_price_on_menu
      }.merge(ml.list.as_json)
    end
  end

  def available_lists
    establishment.lists.includes(:beers) - @menu.lists.includes(:beers)
  end
end
