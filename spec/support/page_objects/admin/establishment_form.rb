module PageObjects
  module Admin
    class EstablishmentForm < SitePrism::Page
      set_url '/accounts{/account_id}/establishments{/establishment_id}/edit'

      class ListsPanel < SitePrism::Section
        class List < SitePrism::Section
          element :toggle_snippet_button, '[data-test="get-snippet"]'
          element :html_snippet, '[data-test="list-html-snippet"]'
          element :link, '[data-test="establishment-list"]'

          def name
            link.text
          end

          def show_snippet
            toggle_snippet_button.click unless has_html_snippet?
          end

          def hide_snippet
            toggle_snippet_button.click if has_html_snippet?
          end
        end

        element :add_list_button, '[data-test="add-list"]'
        sections :lists, List, '[data-test="establishment-list-item"]'

        def add_list
          add_list_button.click
        end
      end

      element :name_input,        '[data-test="establishment-name"]'
      element :url_input,         '[data-test="establishment-url"]'
      element :street_input,      '[data-test="establishment-street-address"]'
      element :city_input,        '[data-test="establishment-city"]'
      element :state_input,       '[data-test="establishment-state"]'
      element :postal_code_input, '[data-test="establishment-postal-code"]'
      element :submit_button,     '[data-test="establishment-form-submit"]'
      element :cancel_link,       '[data-test="establishment-form-cancel"]'
      element :delete_button,     '[data-test="establishment-form-delete"]'

      section :lists_panel, ListsPanel, '[data-test="lists"]'

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

      def set_name(name)
        name_input.set name
      end

      def set_url(url)
        url_input.set url
      end

      def set_street(street)
        street_input.set street
      end

      def set_city(city)
        city_input.set city
      end

      def set_state(state)
        state_input.select state
      end

      def set_postal_code(postal_code)
        postal_code_input.set postal_code
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

      def get_snippet_for(list_name)
        list = list_named list_name
        list.show_snippet
        list.html_snippet.text
      end
    end
  end
end
