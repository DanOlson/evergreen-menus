class MenuPreviewGenerator
  class << self
    def generate(menu_params, ability)
      new(menu_params, ability).generate_pdf
    end
  end

  attr_reader :options

  def initialize(options, ability)
    @options = options
    @ability = ability
  end

  def generate_pdf
    pdf_class = Menu::Templates.pdf_class_for options[:template]
    pdf_class.new menu: menu, lists: ordered_lists
  end

  def menu
    @menu ||= Menu.new options.merge(updated_at: Time.now)
  end

  def lists
    @lists ||= begin
      item_ids_by_list_id = menu_lists_attributes.index_by { |attrs| attrs[:list_id] }
      lists = List.where(id: item_ids_by_list_id.keys).accessible_by(@ability).select("lists.*, true as show_price_on_menu, '{}'::json as list_item_metadata")
      lists.each do |list|
        metadata = item_ids_by_list_id[list.id.to_s][:list_item_metadata] || {}
        list.list_item_metadata = metadata
      end
      lists
    end
  end

  def ordered_lists
    menu_lists_attributes.inject([]) do |memo, menu_list_attr|
      list = lists.find { |l| menu_list_attr[:list_id].to_i == l.id }
      list.show_price_on_menu = menu_list_attr[:show_price_on_menu] == 'true'
      memo << list
    end
  end

  def menu_lists_attributes
    options.fetch(:menu_lists_attributes) do
      {}
    end.values
  end
end
