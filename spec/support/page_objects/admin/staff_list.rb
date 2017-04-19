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
    end

    class PendingInvitations < SitePrism::Section
    end

    class StaffList < SitePrism::Page
      set_url "/accounts{/account_id}/staff"

      section :staff_panel, StaffPanel, '[data-test="staff-panel"]'
      section :pending_invitations, PendingInvitations, '[data-test="pending-invitations-panel"]'

      def member_named(name)
        staff_panel.staff_members.find { |m| m.name == name }
      end
    end
  end
end
