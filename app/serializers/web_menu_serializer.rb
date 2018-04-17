class WebMenuSerializer
  include Rails.application.routes.url_helpers
  TIME_FORMAT = '%I:%M %p'

  def initialize(web_menu, include_embed_code: true, can_view_web_integrations: false, host:, protocol:)
    @web_menu = web_menu
    @host = host
    @protocol = protocol
    @include_embed_code = include_embed_code
    @can_view_web_integrations = can_view_web_integrations
  end

  def call
    additional_attrs = {
      syncToGoogle: sync_to_google?,
      showSyncToGoogleInput: show_sync_to_google?,
      lists: lists.as_json,
      listsAvailable: available_lists,
      previewPath: preview_path,
      availabilityStartTime: availability_start,
      availabilityEndTime: availability_end,
      restrictedAvailability: @web_menu.restricted_availability?
    }

    additional_attrs.merge!(
      embedCode: embed_code,
      ampEmbedCode: amp_embed_code,
      ampHeadEmbedCode: amp_head_embed_code
    ) if @web_menu.persisted?
    @web_menu.as_json.merge(additional_attrs).to_json
  end

  private

  def availability_start
    restriction = @web_menu.availability_start_time and restriction.strftime(TIME_FORMAT)
  end

  def availability_end
    restriction = @web_menu.availability_end_time and restriction.strftime(TIME_FORMAT)
  end

  def gmb_enabled?
    @gmb_enabled ||= establishment.account.google_my_business_enabled?
  end

  def show_sync_to_google?
    gmb_enabled? && !!@can_view_web_integrations
  end

  def sync_to_google?
    return false unless gmb_enabled?
    @web_menu.sync_to_google == nil || @web_menu.sync_to_google?
  end

  def establishment
    @establishment ||= @web_menu.establishment
  end

  def lists
    @web_menu.web_menu_lists.includes(list: :beers).map do |ml|
      list = ListSerializer.new(ml.list).call(as_json: true)
      {
        web_menu_list_id: ml.id,
        show_price_on_menu: ml.show_price_on_menu,
        show_description_on_menu: ml.show_description_on_menu
      }.merge(list)
    end
  end

  def available_lists
    available = establishment.lists.includes(:beers) - @web_menu.lists.includes(:beers)
    available.map { |list| ListSerializer.new(list).call(as_json: true) }
  end

  def preview_path
    account_establishment_web_menu_preview_path(
      establishment.account,
      establishment
    )
  end

  def embed_code
    if @include_embed_code
      MenuEmbedCode.new({
        web_menu: @web_menu,
        menu_url: web_menu_url(@web_menu.id, host: @host, protocol: @protocol)
      }).generate_encoded
    end
  end

  def amp_embed_code
    if @include_embed_code
      AmpMenuEmbedCode.new(@web_menu, {
        base_url: @host
      }).generate_encoded
    end
  end

  def amp_head_embed_code
    if @include_embed_code
      AmpMenuEmbedCode.new(@web_menu, {
        base_url: @host
      }).generate_head_encoded
    end
  end
end
