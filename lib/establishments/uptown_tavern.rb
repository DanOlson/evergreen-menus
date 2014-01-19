module BeerList
  module Establishments
    class UptownTavern < Establishment
      URL     = 'http://uptowntavernmpls.com/menus/'
      ADDRESS = '1400 Lagoon Ave, Minneapolis, MN 55408'

      def get_list
        base_list
        strip_abv
      end

      def url
        URL
      end

      def address
        ADDRESS
      end

      private

      def base_list
        @beers = page.search('div.wp-tab-content-wrapper').slice(3).search('h3').map &:text
      end

      def strip_abv
        @beers = @beers.map { |beer| beer.match(/\d{1,2}\.?\d?%/); $` }.compact
      end
    end
  end
end
