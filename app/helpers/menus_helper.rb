module MenusHelper
  def menu_json(menu)
    MenuSerializer.new(menu).call
  end

  def menu_font_options
    Menu::FONTS
  end

  def menu_template_options
    Menu::TEMPLATES
  end
end
