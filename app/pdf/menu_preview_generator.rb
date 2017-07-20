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
    MenuBasicPdf.new menu: menu, lists: ordered_lists
  end

  def menu
    @menu ||= Menu.new options.merge(updated_at: Time.now)
  end

  def lists
    @lists ||= begin
      list_ids = menu_lists_attributes.map { |attrs| attrs[:list_id] }
      List.where(id: list_ids).accessible_by(@ability).select('lists.*, true as show_price_on_menu')
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
