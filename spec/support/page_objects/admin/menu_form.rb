require 'open-uri'

module PageObjects
  module Admin
    class MenuForm < SitePrism::Page
      set_url_matcher %r{/accounts/\d+/establishments/\d+/menus/(new|\d+/edit)}

      class ListsSelected < SitePrism::Section
        class List < SitePrism::Section
          element :remove_button, '[data-test="remove-list"]'
          element :show_price_input, '[data-test="show-price"]'
          element :show_price_input_label, '[data-test="show-price-label"]'
          element :name_wrapper, '[data-test="list-name"]'

          def name
            name_wrapper.text
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

          def name
            name_wrapper.text
          end
        end

        sections :lists, List, '[data-test="menu-list"]'

        def empty?
          lists.size == 0
        end
      end

      class MenuPreview < SitePrism::Section
        element :pdf, '[data-test="menu-pdf"]'

        def url
          pdf['data']
        end

        def pdf_content
          cookie = "_beermapper_session=#{page.driver.cookies['_beermapper_session']}"
          io = open(Capybara.app_host + url, 'Cookie' => cookie)
          reader = PDF::Reader.new io
          reader.pages.map(&:text).join("\n")
        end
      end

      element :name_input,      '[data-test="menu-name"]'
      element :submit_button,   '[data-test="menu-form-submit"]'
      element :cancel_link,     '[data-test="menu-form-cancel"]'
      element :delete_button,   '[data-test="menu-form-delete"]'
      element :download_button, '[data-test="menu-download-button"]'

      section :menu_preview, MenuPreview, '[data-test="menu-preview"]'
      section :lists_available, ListsAvailable, '[data-test="menu-lists-available"]'
      section :lists_selected, ListsSelected, '[data-test="menu-lists-selected"]'

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
