module PageObjects
  module Admin
    module ListSelectable
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

      class << self
        def included(base)
          base.class_eval do
            section :lists_available, ListsAvailable, '[data-test="menu-lists-available"]'
            section :lists_selected, ListsSelected,   '[data-test="menu-lists-selected"]'
          end
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
    end
  end
end
