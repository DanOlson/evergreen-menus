module PageObjects
  module Admin
    class AccountForm < SitePrism::Page
      set_url_matcher %r{/accounts/(new|\d+/edit)}

      element :name_input, '[data-test="account-name"]'
      element :active_input, '[data-test="account-active"]'
      element :submit_button, '[data-test="account-form-submit"]'
      element :cancel_button, '[data-test="account-form-cancel"]'
      element :delete_button, '[data-test="account-form-delete"]'

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
    end
  end
end
