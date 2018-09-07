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
          cookie = "_evergreen_session=#{page.driver.cookies['_evergreen_session']}"
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

      class EmbedCodeOptions < SitePrism::Section
        class EmbedCode < SitePrism::Section
          element :code, '[data-test="menu-embed-code"]'

          def get_code
            code.text
          end
        end

        section :canonical, EmbedCode, '[data-test="canonical-embed-code"]'
        section :amp, EmbedCode, '[data-test="amp-embed-code"]'
        section :amp_head, EmbedCode, '[data-test="amp-head-embed-code"]'

        element :amp_choice, '[data-test="show-amp"]'
        element :canonical_choice, '[data-test="show-canonical"]'

        def show_amp
          amp_choice.click
        end

        def show_canonical
          canonical_choice.click
        end
      end

      element :name_input,               '[data-test="web-menu-name"]'
      element :submit_button,            '[data-test="web-menu-form-submit"]'
      element :cancel_link,              '[data-test="web-menu-form-cancel"]'
      element :delete_button,            '[data-test="web-menu-form-delete"]'
      element :toggle_embed_code_button, '[data-test="get-embed-code"]'
      element :help_icon,                '[data-test="help-icon"]'
      element :help_text,                '[data-test="help-text"]'

      section :embed_code_options, EmbedCodeOptions, '[data-test="embed-code-options"]'
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

      def get_embed_code(type: :canonical)
        show_embed_code_options
        embed_code_options.public_send(type).get_code
      end

      def show_embed_code_options
        toggle_embed_code_button.click unless has_embed_code_options?
      end

      def hide_embed_code_options
        toggle_embed_code_button.click if has_embed_code_options?
      end

      def has_canonical_embed_code?
        embed_code_options.has_canonical?
      end

      def has_amp_head_embed_code?
        embed_code_options.has_amp_head?
      end

      def has_amp_body_embed_code?
        embed_code_options.has_amp?
      end

      def show_canonical_embed_code
        embed_code_options.show_canonical
      end

      def show_amp_embed_code
        embed_code_options.show_amp
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
