class DigitalDisplayMenuPreviewGenerator
  attr_reader :options

  def initialize(options, ability)
    @options = options
    @ability = ability
  end

  def call
    display = DigitalDisplayMenu.new options
    display.lists = ordered_lists
    display
  end

  ###
  # Get the actual List objects and tack on the attributes
  # we expect to populate from the menu_list_item.
  def lists
    @lists ||= begin
      list_ids = digital_display_menu_lists_attributes.map { |attrs| attrs[:list_id] }
      List.where(id: list_ids).accessible_by(@ability).select('lists.*, 0 as position, true as show_price_on_menu')
    end
  end

  ###
  # Use +lists+, but augment them with data from the menu_list_item
  # such as show_price_on_menu, and position.
  def ordered_lists
    digital_display_menu_lists_attributes.inject([]) do |memo, dd_menu_list_attr|
      list = lists.find { |l| dd_menu_list_attr[:list_id].to_i == l.id }
      list.show_price_on_menu = dd_menu_list_attr[:show_price_on_menu] == 'true'
      list.position = dd_menu_list_attr[:position]
      memo << list
    end.sort_by &:position
  end

  def digital_display_menu_lists_attributes
    options.fetch(:digital_display_menu_lists_attributes) do
      {}
    end.values
  end
end
