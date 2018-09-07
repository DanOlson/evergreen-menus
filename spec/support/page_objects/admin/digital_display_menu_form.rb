require_relative './roles/list_selectable'

module PageObjects
  module Admin
    class DigitalDisplayMenuForm < SitePrism::Page
      set_url_matcher %r{/accounts/\d+/establishments/\d+/digital_displays/(new|\d+/edit)}

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
          cookie = "_evergreen_session=#{page.driver.cookies['_evergreen_session']}"
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

      element :name_input,                   '[data-test="digital-display-menu-name"]'
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

      include ListSelectable

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
    end
  end
end
