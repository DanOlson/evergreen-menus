module PageObjects
  module Admin
    class AccountDetails < SitePrism::Page
      elements :establishments, '[data-test="establishment"]'

      def has_establishment?(name)
        !!establishments.find { |e| e.text == name }
      end
    end
  end
end
