class WebMenuPreviewGenerator
  attr_reader :options

  def initialize(options, ability)
    @options = options
    @ability = ability
  end

  def call
    menu = WebMenu.new options
    menu.lists = ordered_lists
    menu
  end

  private

  ###
  # Get the actual List objects and tack on the attributes
  # we expect to populate from the web_menu_list_item.
  def lists
    @lists ||= begin
      list_ids = web_menu_lists_attributes.map { |attrs| attrs[:list_id] }
      attrs = 'lists.*, 0 as position, true as show_price_on_menu, true as show_description_on_menu'
      List.where(id: list_ids).accessible_by(@ability).select(attrs)
    end
  end

  ###
  # Use +lists+, but augment them with data from the web_menu_list_item
  # such as show_price_on_menu, and position.
  def ordered_lists
    web_menu_lists_attributes.inject([]) do |memo, web_menu_list_attr|
      list = lists.find { |l| web_menu_list_attr[:list_id].to_i == l.id }
      list.show_price_on_menu = web_menu_list_attr[:show_price_on_menu] == 'true'
      list.show_description_on_menu = web_menu_list_attr[:show_description_on_menu] == 'true'
      list.position = web_menu_list_attr[:position]
      memo << list
    end.sort_by &:position
  end

  def web_menu_lists_attributes
    options.fetch(:web_menu_lists_attributes) do
      {}
    end.values
  end
end
