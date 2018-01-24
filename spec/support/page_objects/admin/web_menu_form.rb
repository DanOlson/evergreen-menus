require_relative './roles/availability_restrictable'
require_relative './roles/list_selectable'

module PageObjects
  module Admin
    class WebMenuForm < SitePrism::Page
      set_url_matcher %r{/accounts/\d+/establishments/\d+/web_menus/(new|\d+/edit)}

      class WebMenuPreview < SitePrism::Section
        class List < SitePrism::Section
          class ListItem < SitePrism::Section
            element :name_elem, '[data-test="list-item-name"]'
            element :price_elem, '[data-test="list-item-price"]'
            element :description_elem, '[data-test="list-item-description"]'

            alias_method :has_price?, :has_price_elem?

            def name
              name_elem.text.strip
            end

            def price
              price_elem.text.strip
            end

            def description
              description_elem.text.strip
            end
          end

          element :title_elem, '[data-test="list-title"]'
          sections :items, ListItem, '[data-test="list-item"]'

          def title
            title_elem.text
          end

          def has_item?(name)
            !!item_named(name)
          end

          def item_named(name)
            items.find { |i| i.name == name }
          end
        end

        element :availability_restriction_el, '[data-test="availability-restriction"]'
        sections :lists, List, '[data-test="list"]'

        ###
        # Call the HTML <object>'s data url and provide super() with a
        # +root_element+ representing the response. Capybara doesn't
        # seem to load <object>s out of the box.
        def initialize(parent, root_element)
          path = root_element['data']
          cookie = "_beermapper_session=#{page.driver.cookies['_beermapper_session']}"
          open(Capybara.app_host + path, 'Cookie' => cookie) do |io|
            preview_root_element = Capybara::Node::Simple.new io.read
            super(parent, preview_root_element)
          end
        end

        def has_list?(list_name)
          !!list_named(list_name)
        end

        def list_named(list_name)
          lists.find { |list| list.title == list_name }
        end

        def has_availability_restriction?(text=nil)
          if text
            availability_restriction_el.text.strip.end_with? text
          else
            has_availability_restriction_el?
          end
        end
      end

      element :name_input,               '[data-test="web-menu-name"]'
      element :submit_button,            '[data-test="web-menu-form-submit"]'
      element :cancel_link,              '[data-test="web-menu-form-cancel"]'
      element :delete_button,            '[data-test="web-menu-form-delete"]'
      element :toggle_embed_code_button, '[data-test="get-embed-code"]'
      element :embed_code,               '[data-test="menu-embed-code"]'

      section :preview, WebMenuPreview,  '[data-test="web-menu-preview"]'

      include AvailabilityRestrictable
      include ListSelectable

      def name
        name_input.value
      end

      def name=(string)
        name_input.set string
      end

      def submit
        submit_button.click
      end

      def cancel
        cancel_link.click
      end

      def delete
        accept_confirm do
          delete_button.click
        end
      end

      def get_embed_code
        show_embed_code
        embed_code.text
      end

      def show_embed_code
        toggle_embed_code_button.click unless has_embed_code?
      end

      def hide_embed_code
        toggle_embed_code_button.click if has_embed_code?
      end
    end
  end
end
