module WebMenusHelper
  def web_menu_json(web_menu)
    WebMenuSerializer.new(web_menu, {
      include_embed_code: can?(:view_snippet, WebMenu),
      host: url_options[:host],
      protocol: url_options[:protocol]
    }).call
  end
end
