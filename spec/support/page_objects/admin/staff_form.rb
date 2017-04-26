module PageObjects
  module Admin
    class StaffForm < SitePrism::Page
      set_url "/accounts{/account_id}/staff{/staff_id}/edit"

      element :role_input, '[data-test="staff-role-select"]'
      element :submit_button, '[data-test="staff-form-submit"]'
      element :cancel_link, '[data-test="staff-form-cancel"]'
      elements :establishment_access_checkboxes, '[data-test="establishment-access"]'

      def select_role(role_name)
        role_input.select role_name
      end

      def submit
        submit_button.click
      end

      def cancel
        cancel_link.click
      end

      def grant_establishment_access(establishment)
        check establishment.name
      end

      def revoke_establishment_access(establishment)
        uncheck establishment.name
      end
    end
  end
end
