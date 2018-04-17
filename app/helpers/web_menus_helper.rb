module WebMenusHelper
  def web_menu_json(web_menu)
    WebMenuSerializer.new(web_menu, {
      include_embed_code: can?(:view_snippet, WebMenu),
      can_view_web_integrations: can?(:view_web_integrations, Account),
      host: web_menu_host,
      protocol: url_options[:protocol]
    }).call
  end

  private

  def web_menu_host
    APP_CONFIG.fetch(:web_menu_host) { url_options[:host] }
  end
end
