module GoogleMenuHelper
  def google_menu_json(google_menu)
    GoogleMenuSerializer.new(google_menu).call
  end
end
