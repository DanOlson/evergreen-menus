require_relative './roles/list_selectable'
require_relative './web_menu_preview'

module PageObjects
  module Admin
    class OnlineMenuForm < SitePrism::Page
      set_url '/accounts{/account_id}/establishments{/establishment_id}/online_menus{/online_menu_id}/edit'

      element :submit_button, '[data-test="online-menu-form-submit"]'
      element :cancel_link,   '[data-test="online-menu-form-cancel"]'
      section :preview, WebMenuPreview, '[data-test="online-menu-preview"]'

      include ListSelectable

      def name
        name_input.value
      end

      def name=(string)
        name_input.set string
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
