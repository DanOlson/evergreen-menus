module PageObjects
  module Admin
    class AccountDetails < SitePrism::Page
      set_url '/accounts{/id}'

      class WebIntegrations < SitePrism::Section
        element :connect_with_google_button, '[data-test="connect-google-button"]'
        element :disconnect_from_google_button, '[data-test="disconnect-google-button"]'
      end

      elements :establishments, '[data-test="establishment"]'
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

      def name
        title.text
      end
    end
  end
end
