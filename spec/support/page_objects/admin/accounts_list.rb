module PageObjects
  module Admin
    class AccountsList < SitePrism::Page
      set_url '/accounts'

      element :new_account_button, '[data-test="new-account-button"]'
      elements :accounts, '[data-test="account-link"]'

      def has_account_named?(name)
        accounts.any? { |el| el.text == name }
      end
    end
  end
end
