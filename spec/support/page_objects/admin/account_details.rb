module PageObjects
  module Admin
    class AccountDetails < SitePrism::Page
      set_url '/accounts{/id}'

      elements :establishments, '[data-test="establishment"]'
      element :edit_button, '[data-test="edit-account"]'
      element :title, '[data-test="panel-title"]'

      def has_establishment?(name)
        !!establishments.find { |e| e.text == name }
      end

      def name
        title.text
      end
    end
  end
end
