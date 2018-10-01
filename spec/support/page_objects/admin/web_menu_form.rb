require_relative './roles/availability_restrictable'
require_relative './roles/list_selectable'
require_relative './web_menu_preview'

module PageObjects
  module Admin
    class WebMenuForm < SitePrism::Page
      set_url_matcher %r{/accounts/\d+/establishments/\d+/web_menus/(new|\d+/edit)}

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
