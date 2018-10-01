class OnlineMenuPreviewGenerator
  attr_reader :options

  def initialize(options, ability)
    @options = options
    @ability = ability
  end

  def call
    menu = OnlineMenu.new options
    menu.lists = ordered_lists
    menu
  end

  private

  ###
  # Get the actual List objects and tack on the attributes
  # we expect to populate from the online_menu_list_item.
  def lists
    @lists ||= begin
      attrs_by_list_id = online_menu_lists_attributes.index_by { |attrs| attrs[:list_id] }
      attrs = 'lists.*, 0 as position, true as show_price_on_menu, true as show_description_on_menu, \'{}\'::json as list_item_metadata'
      lists = List.where(id: attrs_by_list_id.keys).accessible_by(@ability).select(attrs)
      lists.each do |list|
        list_attrs = attrs_by_list_id[list.id.to_s]
        list.list_item_metadata = list_attrs.fetch(:list_item_metadata, {})
      end
      lists
    end
  end

  ###
  # Use +lists+, but augment them with data from the online_menu_list_item
  # such as show_price_on_menu, and position.
  def ordered_lists
    online_menu_lists_attributes.inject([]) do |memo, online_menu_list_attr|
      list = lists.find { |l| online_menu_list_attr[:list_id].to_i == l.id }
      list.show_price_on_menu = online_menu_list_attr[:show_price_on_menu] == 'true'
      list.show_description_on_menu = online_menu_list_attr[:show_description_on_menu] == 'true'
      list.position = online_menu_list_attr[:position]
      memo << list
    end.sort_by &:position
  end

  def online_menu_lists_attributes
    options.fetch(:online_menu_lists_attributes) do
      {}
    end.values
  end
end
