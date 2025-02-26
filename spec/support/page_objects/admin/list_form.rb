module PageObjects
  module Admin
    class BeerInput < SitePrism::Section
      class PriceOption < SitePrism::Section
        element :price_input, '[data-test="price-input-amount"]'
        element :unit_input, '[data-test="price-input-unit"]'
        element :remove_button, '[data-test="remove-price-option"]'

        def price=(price)
          price_input.set price
        end

        def unit=(unit)
          unit_input.set unit
        end

        def price
          price_input.value
        end

        def unit
          unit_input.value
        end
      end

      element :name_input, '[data-test^="beer-name-input-"]'
      element :price_input, '[data-test^="beer-price-input-"]'
      element :description_input, '[data-test^="beer-description-input-"]'
      element :image_input, '[data-test="beer-image-input"]'
      element :image_label, '[data-test="beer-image-label"]'
      element :toggle_flyout_button, '[data-test="expand-list-item"]'
      element :flyout, '[data-test="menu-item-flyout"]'
      element :remove_button, '[data-test^="remove-beer-"]'
      element :keep_button, '[data-test^="keep-beer-"]'
      element :destroy_flag, '[data-test="marked-for-removal"]', visible: false
      elements :label_inputs, '[data-test="menu-item-label-input"]'
      element :add_price_option_button, '[data-test="add-price-option"]'
      sections :_price_options, PriceOption, '[data-test="menu-item-price-option"]'

      def name=(name)
        name_input.set name
      end

      ###
      # Deprecated - shim to enable API to work with price_options
      def price=(price)
        price_options.first.price = price
      end

      def price_options
        toggle_flyout_button.click unless has_description_input?
        _price_options
      end

      def add_price_option
        toggle_flyout_button.click unless has_description_input?
        add_price_option_button.click
      end

      def remove_price_option(unit_name)
        option = price_options.find { |o| o.unit == unit_name }
        option.remove_button.click
      end

      def description=(description)
        toggle_flyout_button.click unless has_description_input?

        description_input.set description

        toggle_flyout_button.click
      end

      def image=(filepath)
        toggle_flyout_button.click unless has_flyout?
        image_input.set filepath
      end

      def image_label_text
        toggle_flyout_button.click unless has_flyout?
        image_label.text
      end

      def has_valid_image?
        !image_input[:class].include?('js-invalid')
      end

      def labels=(labels)
        toggle_flyout_button.click unless has_flyout?

        label_inputs.each do |input|
          input.set labels.include?(input.value)
        end
      end

      def has_labels?(*labels)
        toggle_flyout_button.click unless has_flyout?

        candidates = label_inputs.select do |input|
          labels.include? input.value
        end

        candidates.all? &:checked?
      end

      def has_no_labels?
        toggle_flyout_button.click unless has_flyout?
        label_inputs.none? &:checked?
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
      set_url '/accounts{/account_id}/establishments{/establishment_id}/lists{/list_id}/edit'

      element :list_name_input,        '[data-test="list-name"]'
      element :list_type_input,        '[data-test="list-type"]'
      element :list_description_input, '[data-test="list-description"]'
      element :list_notes_input,       '[data-test="list-notes"]'
      element :add_beer_button,        '[data-test="add-beer"]'
      element :submit_button,          '[data-test="list-form-submit"]'
      element :cancel_link,            '[data-test="list-form-cancel"]'
      element :delete_link,            '[data-test="list-form-delete"]'

      sections :beers, BeerInput, '[data-test="beer-input"]'

      def empty?
        !has_beers?
      end

      def list_type=(type)
        list_type_input.find(:option, type).select_option
      end

      def list_type
        current_value = list_type_input.value
        list_type_input.find("option[value='#{current_value}']").text
      end

      def set_name(list_name)
        list_name_input.set list_name
      end

      def description=(description)
        list_description_input.set description
      end

      def description
        list_description_input.value
      end

      def notes=(notes)
        list_notes_input.set notes
      end

      def notes
        list_notes_input.value
      end

      def add_beer(beer_name, price: nil, description: nil, image: nil, labels: [], price_options: [])
        add_beer_button.click
        new_beer             = beers.last
        new_beer.name        = beer_name
        new_beer.price       = price if price
        new_beer.description = description
        new_beer.image       = image
        new_beer.labels      = labels
        price_options.each do |option|
          new_price_option = new_beer.price_options.last
          new_price_option.price = option[:price]
          new_price_option.unit = option[:unit]
          new_beer.add_price_option
        end
      end
      alias_method :add_item, :add_beer

      def remove_beer(beer_name)
        beer = beer_named beer_name
        beer.remove
      end
      alias_method :remove_item, :remove_beer

      def keep_beer(beer_name)
        beer = beer_named beer_name
        beer.keep
      end
      alias_method :keep_item, :keep_beer

      def beer_named(beer_name)
        beers.find { |beer| beer.name_input.value == beer_name }
      end
      alias_method :item_named, :beer_named

      def has_beer_named?(beer_name)
        !!beer_named(beer_name)
      end
      alias_method :has_item_named?, :has_beer_named?

      def submit
        submit_button.click
      end

      def cancel
        cancel_link.click
      end

      def delete
        accept_confirm do
          delete_link.click
        end
      end
    end
  end
end
