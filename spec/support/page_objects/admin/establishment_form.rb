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

      class MenusPanel < SitePrism::Section
        class Menu < SitePrism::Section
          element :link, '[data-test="menu-link"]'

          def name
            link.text
          end

          def visit
            link.click
          end
        end

        element :toggle_help_icon, '[data-test="toggle-help-menus"]'
        element :help_text, '[data-test="menus-help-text"]'
        element :add_print_menu_button, '[data-test="add-menu"]'
        element :add_web_menu_button, '[data-test="add-web-menu"]'
        element :add_digital_display_menu_button, '[data-test="add-digital-display-menu"]'
        sections :print_menus, Menu, '[data-test="menu-list-item"]'
        sections :web_menus, Menu, '[data-test="web-menu-list-item"]'
        sections :digital_display_menus, Menu, '[data-test="digital-display-menu-list-item"]'
        section :online_menu, Menu, '[data-test="online-menu-list-item"]'

        def add_print_menu
          add_print_menu_button.click
        end

        def add_web_menu
          add_web_menu_button.click
        end

        def add_digital_display_menu
          add_digital_display_menu_button.click
        end
      end

      element :name_input,        '[data-test="establishment-name"]'
      element :url_input,         '[data-test="establishment-url"]'
      element :logo_input,        '[data-test="establishment-logo"]'
      element :logo_label,        '[data-test="establishment-logo-label"]'
      element :submit_button,     '[data-test="establishment-form-submit"]'
      element :cancel_link,       '[data-test="establishment-form-cancel"]'
      element :delete_button,     '[data-test="establishment-form-delete"]'

      section :lists_panel, ListsPanel, '[data-test="lists"]'
      section :menus_panel, MenusPanel, '[data-test="menus"]'

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
        menus_panel.add_web_menu
      end

      def add_menu
        menus_panel.add_print_menu
      end

      def add_digital_display_menu
        menus_panel.add_digital_display_menu
      end

      def set_name(name)
        name_input.set name
      end

      def set_url(url)
        url_input.set url
      end

      def set_logo(filename)
        logo_input.set filename
      end

      def has_logo_label?(label_text)
        logo_label.text == label_text
      end

      def has_valid_logo?
        !logo_input[:class].include?('js-invalid')
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
        menus_panel.print_menus
      end

      def menu_count
        menus.size
      end

      def has_online_menu?
        menus_panel.has_online_menu?
      end

      def online_menu
        menus_panel.online_menu
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
        menus_panel.web_menus
      end

      def toggle_lists_help
        lists_panel.toggle_help_icon.trigger('click')
      end

      def toggle_menus_help
        menus_panel.toggle_help_icon.trigger('click')
      end

      def add_web_menu_button
        menus_panel.add_web_menu_button
      end

      def add_menu_button
        menus_panel.add_print_menu_button
      end

      def add_digital_display_menu_button
        menus_panel.add_digital_display_menu_button
      end
    end
  end
end
