require_relative './roles/list_selectable'

module PageObjects
  module Admin
    class OnlineMenuForm < SitePrism::Page
      set_url '/accounts{/account_id}/establishments{/establishment_id}/online_menus{/online_menu_id}/edit'

      class Preview < SitePrism::Section
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
      end

      element :submit_button, '[data-test="online-menu-form-submit"]'
      element :cancel_link,   '[data-test="online-menu-form-cancel"]'
      element :help_icon,     '[data-test="help-icon"]'
      element :help_text,     '[data-test="help-text"]'

      section :preview, Preview,  '[data-test="online-menu-preview"]'

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

      def show_help_text
        help_icon.trigger('click') unless has_help_text?
      end

      def hide_help_text
        help_icon.trigger('click') if has_help_text?
      end

      def help_text_content
        help_text.text
      end
    end
  end
end
