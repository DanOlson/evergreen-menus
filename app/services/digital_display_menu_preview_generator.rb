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

  def lists
    @lists ||= begin
      list_ids = digital_display_menu_lists_attributes.map { |attrs| attrs[:list_id] }
      List.where(id: list_ids).accessible_by(@ability).select('lists.*, true as show_price_on_menu')
    end
  end

  def ordered_lists
    digital_display_menu_lists_attributes.inject([]) do |memo, dd_menu_list_attr|
      list = lists.find { |l| dd_menu_list_attr[:list_id].to_i == l.id }
      list.show_price_on_menu = dd_menu_list_attr[:show_price_on_menu] == 'true'
      memo << list
    end
  end

  def digital_display_menu_lists_attributes
    options.fetch(:digital_display_menu_lists_attributes) do
      {}
    end.values
  end
end
