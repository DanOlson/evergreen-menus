module GoogleMyBusiness
  class WebMenuSerializer
    def initialize(web_menu)
      @web_menu = web_menu
    end

    def call
      JSON.generate generate_price_list
    end

    private

    def generate_price_list
      {
        priceListId: @web_menu.name,
        labels: [{ displayName: @web_menu.name }],
        sections: @web_menu.lists.map { |l| generate_section l }
      }
    end

    def generate_section(list)
      {
        sectionId: list.name.gsub(' ', '_').downcase,
        labels: [{ displayName: list.name }],
        items: list.beers.map { |item| generate_item item, list }
      }
    end

    def generate_item(menu_item, list)
      {
        itemId: String(menu_item.id),
        labels: [generate_label(menu_item, list)]
      }.tap do |hsh|
        if list.show_price_on_menu?
          hsh.merge! generate_price(menu_item)
        end
      end
    end

    def generate_label(menu_item, list)
      {
        displayName: menu_item.name
      }.tap do |hsh|
        if list.show_description_on_menu?
          hsh.merge!(description: menu_item.description)
        end
      end
    end

    def generate_price(menu_item)
      price = menu_item.price.to_s
      dollars, cents = price.split('.')
      nanos = cents.ljust(9, '0')
      {
        price: {
          currencyCode: 'USD',
          units: dollars,
          nanos: nanos
        }
      }
    end
  end
end
