module WebMenusHelper
  def web_menu_json(web_menu)
    WebMenuSerializer.new(web_menu, {
      include_embed_code: can?(:view_snippet, WebMenu),
      can_view_web_integrations: can?(:view_web_integrations, Account),
      host: web_menu_host,
      protocol: url_options[:protocol]
    }).call
  end

  def price_options(menu_item)
    menu_item.price_options.map do |option|
      number_to_currency option.price, precision: option.price % 1 > 0 ? 2 : 0
    end.join(' / ')
  end

  private

  def web_menu_host
    APP_CONFIG.fetch(:web_menu_host) { url_options[:host] }
  end
end
