require_relative './roles/availability_restrictable'

module PageObjects
  module Admin
    class WebMenuForm < SitePrism::Page
      set_url_matcher %r{/accounts/\d+/establishments/\d+/web_menus/(new|\d+/edit)}

      class ListsSelected < SitePrism::Section
        class List < SitePrism::Section
          element :remove_button, '[data-test="remove-list"]'
          element :show_price_input, '[data-test="show-price"]'
          element :show_price_input_label, '[data-test="show-price-label"]'
          element :show_descriptions_input, '[data-test="show-descriptions"]'
          element :show_descriptions_input_label, '[data-test="show-descriptions-label"]'
          element :name_wrapper, '[data-test="list-name"]'
          element :badge, '[data-test="list-badge"]'

          def name
            name_wrapper.text
          end

          def badge_text
            badge.text
          end

          def has_price_shown?
            show_price_input.checked?
          end

          def hide_prices
            show_price_input.set false
          end

          def show_prices
            show_price_input.set true
          end

          def has_descriptions_shown?
            show_descriptions_input.checked?
          end

          def hide_descriptions
            show_descriptions_input.set false
          end

          def show_descriptions
            show_descriptions_input.set true
          end
        end

        sections :lists, List, '[data-test="menu-list"]'

        def empty?
          lists.size == 0
        end
      end

      class ListsAvailable < SitePrism::Section
        class List < SitePrism::Section
          element :add_button, '[data-test="add-list"]'
          element :name_wrapper, '[data-test="list-name"]'
          element :badge, '[data-test="list-badge"]'

          def name
            name_wrapper.text
          end

          def badge_text
            badge.text
          end
        end

        sections :lists, List, '[data-test="menu-list"]'

        def empty?
          lists.size == 0
        end
      end

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

      element :name_input,                    '[data-test="web-menu-name"]'
      element :restrict_availability_input,   '[data-test="menu-restricted-availability"]'
      element :availability_end_time_input,   'input[name="web_menu[availability_end_time]"]'
      element :availability_start_time_input, 'input[name="web_menu[availability_start_time]"]'
      element :submit_button,                 '[data-test="web-menu-form-submit"]'
      element :cancel_link,                   '[data-test="web-menu-form-cancel"]'
      element :delete_button,                 '[data-test="web-menu-form-delete"]'
      element :toggle_embed_code_button,      '[data-test="get-embed-code"]'
      element :embed_code,                    '[data-test="menu-embed-code"]'

      section :preview, WebMenuPreview,         '[data-test="web-menu-preview"]'
      section :lists_available, ListsAvailable, '[data-test="menu-lists-available"]'
      section :lists_selected, ListsSelected,   '[data-test="menu-lists-selected"]'

      include AvailabilityRestrictable

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

      def available_list_named(name)
        lists_available.lists.find { |list| list.name == name }
      end

      def has_available_list?(name)
        !!available_list_named(name)
      end

      def selected_list_named(name)
        lists_selected.lists.find { |list| list.name == name }
      end

      def has_selected_list?(name)
        !!selected_list_named(name)
      end

      def select_list(name)
        available_list_named(name).add_button.click
      end

      def remove_list(name)
        selected_list_named(name).remove_button.click
      end

      def hide_prices(list:)
        selected_list_named(list).hide_prices
      end

      def show_prices(list:)
        selected_list_named(list).show_prices
      end

      def hide_descriptions(list:)
        selected_list_named(list).hide_descriptions
      end

      def show_descriptions(list:)
        selected_list_named(list).show_descriptions
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
