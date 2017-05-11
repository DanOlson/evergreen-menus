module PageObjects
  module Admin
    class MenuForm < SitePrism::Page
      set_url_matcher %r{/accounts/\d+/establishments/\d+/menus/(new|\d+/edit)}

      element :name_input,    '[data-test="menu-name"]'
      element :submit_button, '[data-test="menu-form-submit"]'
      element :cancel_link,   '[data-test="menu-form-cancel"]'
      element :delete_button, '[data-test="menu-form-delete"]'

      def name=(string)
        name_input.set string
      end

      def submit
        submit_button.click
      end
    end
  end
end
