module PageObjects
  module Admin
    class StaffPanel < SitePrism::Section
      class StaffMember < SitePrism::Section
        def name
          text
        end

        def click
          root_element.click
        end
      end

      sections :staff_members, StaffMember, '[data-test="staff-member"]'
      element :invite_staff_button, '[data-test="invite-staff-button"]'
    end

    class PendingInvitationsPanel < SitePrism::Section
      elements :invitations, '[data-test="staff-member-invited"]'
    end

    class StaffList < SitePrism::Page
      set_url "/accounts{/account_id}/staff"

      section :staff_panel, StaffPanel, '[data-test="staff-panel"]'
      section :pending_invitations_panel, PendingInvitationsPanel, '[data-test="pending-invitations-panel"]'

      def member_named(name)
        staff_panel.staff_members.find { |m| m.name == name }
      end

      def has_member_named?(name)
        !!member_named(name)
      end

      def invitations
        pending_invitations_panel.invitations
      end

      def invite_staff_button
        staff_panel.invite_staff_button
      end
    end
  end
end
