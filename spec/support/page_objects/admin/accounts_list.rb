module PageObjects
  module Admin
    class AccountsList < SitePrism::Page
      set_url '/accounts'

      element :new_account_button, '[data-test="new-account-button"]'
    end
  end
end
