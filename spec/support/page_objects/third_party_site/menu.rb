module PageObjects
  module ThirdPartySite
    class Menu < SitePrism::Page
      set_url 'http://test.my-bar.dev'

      class MenuItem < SitePrism::Section
        element :name, '.beermapper-menu-item-name'
        element :price, '.beermapper-menu-item-price'
        element :description, '.beermapper-menu-item-description'
      end

      class List < SitePrism::Section
        sections :menu_items, MenuItem, '.beermapper-menu-item'

        def has_prices?
          menu_items.any? { |item| item.has_price? }
        end

        def has_descriptions?
          menu_items.any? { |item| item.has_description? }
        end

        def has_item_named?(name)
          !!item_named(name)
        end

        def item_named(name)
          menu_items.find { |item| item.name.text == name }
        end
      end

      section :list, List, '.beermapper-menu'
    end
  end
end
