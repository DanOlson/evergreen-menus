module PageObjects
  module Admin
    class StaffInvitationForm < SitePrism::Page
      element :first_name_input, '[data-test="invitation-first-name"]'
      element :last_name_input,  '[data-test="invitation-last-name"]'
      element :email_input,      '[data-test="invitation-email"]'
      elements :establishments,  '[data-test="invitation-establishment-access"]'
      element :submit_button,    '[data-test="invitation-submit-button"]'
      element :delete_button,    '[data-test="invitation-delete-button"]'
      element :cancel_link,      '[data-test="invitation-cancel-link"]'

      def first_name=(name)
        first_name_input.set name
      end

      def last_name=(name)
        last_name_input.set name
      end

      def email=(email)
        email_input.set email
      end

      def grant_establishment_access(establishment)
        check establishment.name
      end

      def granted_access_to?(establishment)
        establishment_label = establishments.find do |cb|
          cb.text == establishment.name
        end
        establishment_label.find('input').checked?
      end

      def invite_another
        check 'Invite another'
      end

      def dont_invite_another
        uncheck 'Invite another'
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
