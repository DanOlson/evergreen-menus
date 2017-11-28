module PageObjects
  module Admin
    class EstablishmentForm < SitePrism::Page
      set_url '/accounts{/account_id}/establishments{/establishment_id}/edit'

      class ListsPanel < SitePrism::Section
        class List < SitePrism::Section
          element :link, '[data-test="establishment-list"]'

          def name
            link.text
          end
        end

        element :toggle_help_icon, '[data-test="toggle-help-lists"]'
        element :help_text, '[data-test="lists-help-text"]'
        element :add_button, '[data-test="add-list"]'
        sections :lists, List, '[data-test="establishment-list-item"]'

        def add_list
          add_button.click
        end
      end

      class WebMenusPanel < SitePrism::Section
        class Menu < SitePrism::Section
          element :link, '[data-test="establishment-web-menu"]'
          element :toggle_embed_code_button, '[data-test="get-snippet"]'
          element :embed_code, '[data-test="menu-html-snippet"]'

          def name
            link.text
          end

          def show_embed_code
            toggle_embed_code_button.click unless has_embed_code?
          end

          def hide_embed_code
            toggle_embed_code_button.click if has_embed_code?
          end

          def visit
            link.click
          end
        end

        element :toggle_help_icon, '[data-test="toggle-help-web-menus"]'
        element :help_text, '[data-test="web-menus-help-text"]'
        element :add_button, '[data-test="add-web-menu"]'
        sections :menus, Menu, '[data-test="establishment-web-menu-item"]'

        def add_menu
          add_button.click
        end
      end

      class MenusPanel < SitePrism::Section
        class Menu < SitePrism::Section
          element :print_button, '[data-test="print-menu"]' # TODO
          element :link, '[data-test="establishment-menu"]'

          def name
            link.text
          end

          def visit
            link.click
          end
        end

        element :toggle_help_icon, '[data-test="toggle-help-menus"]'
        element :help_text, '[data-test="menus-help-text"]'
        element :add_button, '[data-test="add-menu"]'
        sections :menus, Menu, '[data-test="menu-list-item"]'

        def add_menu
          add_button.click
        end
      end

      class DigitalDisplayMenusPanel < SitePrism::Section
        class DigitalDisplayMenu < SitePrism::Section
          element :link, '[data-test="establishment-digital-display-menu"]'

          def name
            link.text
          end

          def visit
            link.click
          end
        end

        element :toggle_help_icon, '[data-test="toggle-help-digital-display"]'
        element :help_text, '[data-test="digital-display-menus-help-text"]'
        element :add_button, '[data-test="add-digital-display-menu"]'
        sections :digital_display_menus, DigitalDisplayMenu, '[data-test="digital-display-menu-list-item"]'

        def add_digital_display_menu
          add_button.click
        end
      end

      element :name_input,        '[data-test="establishment-name"]'
      element :url_input,         '[data-test="establishment-url"]'
      element :street_input,      '[data-test="establishment-street-address"]'
      element :city_input,        '[data-test="establishment-city"]'
      element :state_input,       '[data-test="establishment-state"]'
      element :postal_code_input, '[data-test="establishment-postal-code"]'
      element :submit_button,     '[data-test="establishment-form-submit"]'
      element :cancel_link,       '[data-test="establishment-form-cancel"]'
      element :delete_button,     '[data-test="establishment-form-delete"]'

      section :lists_panel, ListsPanel, '[data-test="lists"]'
      section :menus_panel, MenusPanel, '[data-test="menus"]'
      section :web_menus_panel, WebMenusPanel, '[data-test="web-menus"]'
      section :digital_display_menus_panel, DigitalDisplayMenusPanel, '[data-test="digital-display-menus"]'

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

      def add_list
        lists_panel.add_list
      end

      def add_web_menu
        web_menus_panel.add_menu
      end

      def add_menu
        menus_panel.add_menu
      end

      def add_digital_display_menu
        digital_display_menus_panel.add_digital_display_menu
      end

      def set_name(name)
        name_input.set name
      end

      def set_url(url)
        url_input.set url
      end

      def set_street(street)
        street_input.set street
      end

      def set_city(city)
        city_input.set city
      end

      def set_state(state)
        state_input.select state
      end

      def set_postal_code(postal_code)
        postal_code_input.set postal_code
      end

      def lists
        lists_panel.lists
      end

      def has_list_named?(list_name)
        !!list_named(list_name)
      end

      def list_named(list_name)
        lists.find { |l| l.name == list_name }
      end

      def click_list_named(list_name)
        list_named(list_name).link.click
      end

      def menus
        menus_panel.menus
      end

      def menu_count
        menus.size
      end

      def has_menu_named?(menu_name)
        !!menu_named(menu_name)
      end

      def menu_named(menu_name)
        menus.find { |m| m.name == menu_name }
      end

      def web_menu_named(name)
        web_menus.find { |m| m.name == name }
      end

      def web_menus
        web_menus_panel.menus
      end

      def get_snippet_for(menu_name)
        menu = web_menu_named menu_name
        menu.show_embed_code
        menu.embed_code.text
      end

      def toggle_lists_help
        lists_panel.toggle_help_icon.trigger('click')
      end

      def toggle_menus_help
        menus_panel.toggle_help_icon.trigger('click')
      end

      def toggle_digital_display_menus_help
        digital_display_menus_panel.toggle_help_icon.trigger('click')
      end

      def add_web_menu_button
        web_menus_panel.add_button
      end

      def add_menu_button
        menus_panel.add_button
      end

      def add_digital_display_menu_button
        digital_display_menus_panel.add_button
      end
    end
  end
end
