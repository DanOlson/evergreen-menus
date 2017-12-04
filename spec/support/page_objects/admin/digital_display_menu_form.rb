module PageObjects
  module Admin
    class DigitalDisplayMenuForm < SitePrism::Page
      set_url_matcher %r{/accounts/\d+/establishments/\d+/digital_displays/(new|\d+/edit)}

      class ListsSelected < SitePrism::Section
        class List < SitePrism::Section
          element :remove_button, '[data-test="remove-list"]'
          element :show_price_input, '[data-test="show-price"]'
          element :show_price_input_label, '[data-test="show-price-label"]'
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
            uncheck(show_price_input_label.text) if has_price_shown?
          end

          def show_prices
            check(show_price_input_label.text) unless has_price_shown?
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

      class DigitalDisplayMenuPreview < SitePrism::Section
        class List < SitePrism::Section
          class Beer < SitePrism::Section
            element :name_wrapper, '[data-test="digital-display-menu-list-item-name"]'
            element :price_wrapper, '[data-test="digital-display-menu-list-item-price"]'

            def name
              name_wrapper.text.strip
            end

            def price
              price_wrapper.text.strip
            end

            alias_method :has_price?, :has_price_wrapper?
          end

          element :name, '[data-test="digital-display-menu-list-name"]'
          sections :beers, Beer, '[data-test="digital-display-menu-list-item"]'

          def beer_named(beer_name)
            beers.find { |b| b.name == beer_name }
          end

          def has_beer?(beer_name)
            !!beer_named(beer_name)
          end
        end

        sections :lists, List, '[data-test="digital-display-menu-list"]'

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

        def list_named(list_name)
          lists.find { |l| l.name.text.strip == list_name }
        end

        def has_list?(list_name)
          !!list_named(list_name)
        end

        def oriented_vertically?
          lists.first.root_element[:class].include? 'vertical'
        end

        def oriented_horizontally?
          lists.first.root_element[:class].include? 'horizontal'
        end
      end

      element :name_input,          '[data-test="digital-display-menu-name"]'
      element :horizontal_orientation_radio, '[data-test=digital-display-menu-horizontal-orientation-true]'
      element :vertical_orientation_radio,   '[data-test=digital-display-menu-horizontal-orientation-false]'
      element :rotation_interval_input, '[data-test="digital-display-menu-rotation-interval"]'
      element :theme_input,             '[data-test="digital-display-menu-theme"]'
      element :font_input,              '[data-test="digital-display-menu-font"]'
      element :background_color_input,  '[data-test="digital-display-menu-background-color"]'
      element :text_color_input,        '[data-test="digital-display-menu-text-color"]'
      element :list_title_color_input,  '[data-test="digital-display-menu-list-title-color"]'
      element :submit_button,           '[data-test="digital-display-menu-form-submit"]'
      element :cancel_link,             '[data-test="digital-display-menu-form-cancel"]'
      element :delete_button,           '[data-test="digital-display-menu-form-delete"]'
      element :view_display_button,     '[data-test="view-digital-display-menu"]'

      section :preview, DigitalDisplayMenuPreview, '[data-test="digital-display-menu-preview"]'
      section :lists_available, ListsAvailable, '[data-test="menu-lists-available"]'
      section :lists_selected, ListsSelected, '[data-test="menu-lists-selected"]'

      def name=(string)
        name_input.set string
      end

      def name
        name_input.value
      end

      def theme=(theme)
        theme_input.find(:option, theme).select_option
      end

      def theme
        current_value = theme_input.value
        theme_input.find("option[value='#{current_value}']").text
      end

      def rotation_interval=(interval)
        rotation_interval_input.find(:option, interval).select_option
      end

      def rotation_interval
        current_value = rotation_interval_input.value
        rotation_interval_input.find("option[value='#{current_value}']").text
      end

      def set_orientation(o)
        radio = {
          horizontal: horizontal_orientation_radio,
          vertical: vertical_orientation_radio
        }.fetch(o)
        radio.set(true);
      end

      def orientation
        horizontal_orientation_radio.checked? ? :horizontal : :vertical
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

      def visit_digital_display_menu
        view_display_button.click
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
    end
  end
end
