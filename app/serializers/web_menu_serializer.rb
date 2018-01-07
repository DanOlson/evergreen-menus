class WebMenuSerializer
  include Rails.application.routes.url_helpers

  def initialize(web_menu, include_embed_code: true, host:, protocol:)
    @web_menu = web_menu
    @host = host
    @protocol = protocol
    @include_embed_code = include_embed_code
  end

  def call
    additional_attrs = {
      lists: lists.as_json,
      listsAvailable: available_lists.as_json,
      previewPath: preview_path
    }

    additional_attrs.merge!(embedCode: embed_code) if @web_menu.persisted?
    @web_menu.as_json.merge(additional_attrs).to_json
  end

  private

  def establishment
    @establishment ||= @web_menu.establishment
  end

  def lists
    @web_menu.web_menu_lists.includes(list: :beers).map do |ml|
      {
        web_menu_list_id: ml.id,
        show_price_on_menu: ml.show_price_on_menu,
        show_description_on_menu: ml.show_description_on_menu
      }.merge(ml.list.as_json)
    end
  end

  def available_lists
    establishment.lists.includes(:beers) - @web_menu.lists.includes(:beers)
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
end
