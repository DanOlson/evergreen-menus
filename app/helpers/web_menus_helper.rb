module WebMenusHelper
  def web_menu_json(web_menu)
    WebMenuSerializer.new(web_menu).call
  end
end
