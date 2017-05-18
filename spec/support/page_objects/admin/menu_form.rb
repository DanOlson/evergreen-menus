module PageObjects
  module Admin
    class MenuForm < SitePrism::Page
      set_url_matcher %r{/accounts/\d+/establishments/\d+/menus/(new|\d+/edit)}

      class ListsSelected < SitePrism::Section
        class List < SitePrism::Section
          element :remove_button, '[data-test="remove-list"]'

          def name
            text
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

          def name
            text
          end
        end

        sections :lists, List, '[data-test="menu-list"]'

        def empty?
          lists.size == 0
        end
      end

      element :name_input,    '[data-test="menu-name"]'
      element :submit_button, '[data-test="menu-form-submit"]'
      element :cancel_link,   '[data-test="menu-form-cancel"]'
      element :delete_button, '[data-test="menu-form-delete"]'

      section :lists_available, ListsAvailable, '[data-test="menu-lists-available"]'
      section :lists_selected, ListsSelected, '[data-test="menu-lists-selected"]'

      def name=(string)
        name_input.set string
      end

      def submit
        submit_button.click
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
    end
  end
end
