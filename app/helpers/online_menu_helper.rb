module OnlineMenuHelper
  def online_menu_json(online_menu)
    OnlineMenuSerializer.new(online_menu).call
  end
end
