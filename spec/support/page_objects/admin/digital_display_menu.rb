module PageObjects
  module Admin
    class DigitalDisplayMenu < SitePrism::Page
      set_url_matcher %r{/accounts/\d+/establishments/\d+/digital_displays/\d+}

      class MenuList < SitePrism::Section
        class ListItem < SitePrism::Section
          element :item_name, '[data-test="digital-display-menu-list-item-name"]'
          element :item_price, '[data-test="digital-display-menu-list-item-price"]'

          def name
            item_name.text
          end

          def price
            item_price.text
          end

          def has_price?
            has_item_price?
          end
        end

        element :list_name, '[data-test="digital-display-menu-list-name"]'
        sections :list_items, ListItem, '[data-test="digital-display-menu-list-item"]'

        def name
          list_name.text
        end

        def beer_named(name)
          list_items.find { |i| i.name == name }
        end

        def has_beer_named?(name)
          !!beer_named(name)
        end
      end

      sections :menu_lists, MenuList, '[data-test="digital-display-menu-list"]'

      def list_named(name)
        menu_lists.find { |l| l.name.downcase == name.downcase }
      end

      def has_list_named?(name)
        !!list_named(name)
      end
    end
  end
end
