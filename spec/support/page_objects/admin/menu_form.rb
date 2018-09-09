require 'open-uri'
require_relative './roles/availability_restrictable'
require_relative './roles/list_selectable'
require_relative '../../authentication_helper'

module PageObjects
  module Admin
    class MenuForm < SitePrism::Page
      set_url_matcher %r{/accounts/\d+/establishments/\d+/print_menus/(new|\d+/edit)}

      class MenuPreview < SitePrism::Section
        include AuthenticationHelper

        element :pdf, '[data-test="menu-pdf"]'

        def url
          pdf['data']
        end

        def pdf_content
          pdf_reader.pages.map(&:text).join("\n")
        end

        def has_font?(font)
          expected_font = font.to_sym
          actual_font = pdf_reader.page(1).fonts[:"F1.0"][:BaseFont]
          actual_font == expected_font
        end

        private

        def pdf_reader
          @pdf_reader ||= begin
            io = open(Capybara.app_host + url, 'Cookie' => session_cookie)
            PDF::Reader.new io
          end
        end
      end

      element :name_input,      '[data-test="menu-name"]'
      element :template_input,  '[data-test="menu-template"]'
      element :font_input,      '[data-test="menu-font"]'
      element :font_size_input, '[data-test="menu-font-size"]'
      elements :columns_inputs, '[data-test^="menu-columns"]'
      element :submit_button,   '[data-test="menu-form-submit"]'
      element :cancel_link,     '[data-test="menu-form-cancel"]'
      element :delete_button,   '[data-test="menu-form-delete"]'
      element :download_button, '[data-test="menu-download-button"]'

      section :menu_preview, MenuPreview, '[data-test="menu-preview"]'

      include AvailabilityRestrictable
      include ListSelectable

      def preview_url
        menu_preview.url
      end

      def preview_content
        menu_preview.pdf_content
      end

      def has_preview_content?(content)
        preview_content.include? content
      end

      def name=(string)
        name_input.set string
      end

      def template=(template)
        template_input.find(:option, template).select_option
      end

      def template
        template_input.value
      end

      def font=(font)
        font_input.find(:option, font).select_option
      end

      def font_size=(font_size)
        font_size_input.set font_size
      end

      def columns=(n)
        input = columns_inputs.find { |i| i.value == n.to_s }
        input.set true
      end

      def columns
        input = columns_inputs.find &:checked?
        Integer(input.value)
      end

      def has_column_choices_disabled?
        columns_inputs.all? &:disabled?
      end

      def has_font_size?(font_size)
        font_size_input.value == String(font_size)
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
    end
  end
end
