module PageObjects
  module Admin
    class StaffForm < SitePrism::Page
      set_url "/accounts{/account_id}/staff{/staff_id}/edit"

      element :staff_header,  '[data-test="panel-title"]'
      element :role_input,    '[data-test="staff-role-select"]'
      element :submit_button, '[data-test="staff-form-submit"]'
      element :delete_button, '[data-test="staff-form-delete"]'
      element :cancel_link,   '[data-test="staff-form-cancel"]'
      elements :establishment_access_checkboxes, '[data-test="establishment-access"]'

      def name
        staff_header.text
      end

      def select_role(role_name)
        role_input.select role_name
      end

      def role
        role_input.find('option[selected]').text
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

      def grant_establishment_access(establishment)
        check establishment.name
      end

      def revoke_establishment_access(establishment)
        uncheck establishment.name
      end
    end
  end
end
