module BeerList
  module Establishments
    class BustersOn28th < Establishment
      URL     = 'http://menus.singleplatform.co/storefront/menus/busters-on-28th.js?callback=businessView.defaultApiCallResponseHandler&ref=&current_announcement=1&photos=1&display_menu=1593755&menuIntegrate=2&apiKey=ke09z8icq4xu8uiiccighy1bw'
      ADDRESS = '4204 S 28th Ave, Minneapolis, Minnesota 55406'

      def get_list
        document.search('//storefront//item_title').map &:text
      end

      def url
        URL
      end

      def address
        ADDRESS
      end

      private

      def document
        Nokogiri::XML xml
      end

      def xml
        match = page.body.match /defaultApiCallResponseHandler\(\'(.*)\'\,\s\'{"/
        match.captures[0]
      end
    end
  end
end
