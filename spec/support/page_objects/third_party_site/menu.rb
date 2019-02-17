module PageObjects
  module ThirdPartySite
    class Menu < SitePrism::Page
      set_url 'http://test.my-bar.locl'

      element :schema_dot_org_markup, '[data-test="json-linked-data"]', visible: false
      element :stylesheet, '[data-test="evergreen-global-stylesheet"]', visible: false
      elements :stylesheets, '[data-test="evergreen-global-stylesheet"]', visible: false

      class MenuItem < SitePrism::Section
        class Image < SitePrism::Section
          element :img, 'img'
          def src
            URI(img[:src])
          end
        end

        element :name, '[data-test="list-item-name"]'
        element :price, '[data-test="list-item-price"]'
        element :description, '[data-test="list-item-description"]'
        section :image, Image, '[data-test="list-item-image"]'
      end

      class List < SitePrism::Section
        sections :menu_items, MenuItem, '[data-test="list-item"]'
        element :_title, '[data-test="list-title"]'
        element :_description, '[data-test="list-description"]'

        def has_prices?
          menu_items.any? &:has_price?
        end

        def has_descriptions?
          menu_items.any? &:has_description?
        end

        def has_item_named?(name)
          !!item_named(name)
        end

        def item_named(name)
          menu_items.find { |item| item.name.text == name }
        end

        def description
          _description.text
        end

        def title
          _title.text
        end
      end

      sections :lists, List, '.evergreen-menu'

      def list_named(name)
        lists.find { |l| l.title == name }
      end

      def has_list_named?(name)
        !!list_named(name)
      end
    end
  end
end
