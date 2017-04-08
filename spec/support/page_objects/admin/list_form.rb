module PageObjects
  module Admin
    class BeerInput < SitePrism::Section
      element :name_input, '[data-test^="beer-name-input-"]'
      element :price_input, '[data-test^="beer-price-input-"]'
      element :description_input, '[data-test^="beer-description-input-"]'
      element :remove_button, '[data-test^="remove-beer-"]'
      element :keep_button, '[data-test^="keep-beer-"]'
      element :destroy_flag, '[data-test="marked-for-removal"]', visible: false

      def name=(name)
        name_input.set name
      end

      def price=(price)
        price_input.set price
      end

      def description=(description)
        description_input.set description
      end

      def marked_for_removal?
        destroy_flag.value == 'true'
      end

      def remove
        remove_button.click
      end

      def keep
        keep_button.click
      end
    end

    class ListForm < SitePrism::Page
      element :list_name_input,           '[data-test="list-name"]'
      element :show_price_checkbox,       '[data-test="list-show-price"]'
      element :show_description_checkbox, '[data-test="list-show-description"]'

      element :add_beer_button, '[data-test="add-beer"]'
      element :submit_button,   '[data-test="list-form-submit"]'
      element :cancel_link,     '[data-test="list-form-cancel"]'

      sections :beers, BeerInput, '[data-test="beer-input"]'

      def empty?
        !has_beers?
      end

      def hide_prices
        if show_price_checkbox.checked?
          show_price_checkbox.click
        end
      end

      def show_prices
        if !show_price_checkbox.checked?
          show_price_checkbox.click
        end
      end

      def hide_descriptions
        if show_description_checkbox.checked?
          show_description_checkbox.click
        end
      end

      def show_descriptions
        if !show_description_checkbox.checked?
          show_description_checkbox.click
        end
      end

      def set_name(list_name)
        list_name_input.set list_name
      end

      def add_beer(beer_name, price: nil, description: nil)
        add_beer_button.click
        new_beer             = beers.last
        new_beer.name        = beer_name
        new_beer.price       = price
        new_beer.description = description
      end

      def remove_beer(beer_name)
        beer = beer_named beer_name
        beer.remove
      end

      def keep_beer(beer_name)
        beer = beer_named beer_name
        beer.keep
      end

      def beer_named(beer_name)
        beers.find { |beer| beer.name_input.value == beer_name }
      end

      def has_beer_named?(beer_name)
        !!beer_named(beer_name)
      end

      def submit
        submit_button.click
      end

      def cancel
        cancel_link.click
      end
    end
  end
end
