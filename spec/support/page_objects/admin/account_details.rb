module PageObjects
  module Admin
    class AccountDetails < SitePrism::Page
      set_url '/accounts{/id}'

      class WebIntegrations < SitePrism::Section
        element :connect_with_google_button, '[data-test="connect-google-button"]'
        element :disconnect_from_google_button, '[data-test="disconnect-google-button"]'
        element :edit_google_link, '[data-test="edit-google-link"]'
        element :status_google_enabled, '[data-test="status-google-integration-enabled"]'
        element :status_google_disabled, '[data-test="status-google-integration-disabled"]'

        element :connect_with_facebook_button, '[data-test="connect-facebook-button"]'
        element :disconnect_from_facebook_button, '[data-test="disconnect-facebook-button"]'
        element :edit_facebook_link, '[data-test="edit-facebook-link"]'
        element :status_facebook_enabled, '[data-test="status-facebook-integration-enabled"]'
        element :status_facebook_disabled, '[data-test="status-facebook-integration-disabled"]'
      end

      elements :establishments, '[data-test="establishment"]'
      element :add_establishment_button, '[data-test="add-establishment"]'
      element :edit_button, '[data-test="edit-account"]'
      element :title, '[data-test="panel-title"]'

      section :web_integrations, WebIntegrations, '[data-test="account-integrations"]'

      def has_establishment?(name)
        !!establishments.find { |e| e.text == name }
      end

      def has_connect_with_google_button?
        has_web_integrations? && web_integrations.has_connect_with_google_button?
      end

      def has_disconnect_from_google_button?
        has_web_integrations? && web_integrations.has_disconnect_from_google_button?
      end

      def has_google_enabled_status?
        has_web_integrations? && web_integrations.has_status_google_enabled?
      end

      def has_google_disabled_status?
        has_web_integrations? && web_integrations.has_status_google_disabled?
      end

      def has_edit_google_link?
        has_web_integrations? && web_integrations.has_edit_google_link?
      end

      def has_connect_with_facebook_button?
        has_web_integrations? && web_integrations.has_connect_with_facebook_button?
      end

      def has_disconnect_from_facebook_button?
        has_web_integrations? && web_integrations.has_disconnect_from_facebook_button?
      end

      def has_facebook_enabled_status?
        has_web_integrations? && web_integrations.has_status_facebook_enabled?
      end

      def has_facebook_disabled_status?
        has_web_integrations? && web_integrations.has_status_facebook_disabled?
      end

      def has_edit_facebook_link?
        has_web_integrations? && web_integrations.has_edit_facebook_link?
      end

      def name
        title.text
      end

      def add_establishment
        add_establishment_button.click
      end
    end
  end
end
