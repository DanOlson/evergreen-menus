module PageObjects
  module Admin
    class StaffForm < SitePrism::Page
      set_url "/accounts{/account_id}/staff{/staff_id}/edit"

      element :role_input, '[data-test="staff-role-select"]'
      element :submit_button, '[data-test="staff-form-submit"]'
      element :cancel_link, '[data-test="staff-form-cancel"]'

      def select_role(role_name)
        role_input.select role_name
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
