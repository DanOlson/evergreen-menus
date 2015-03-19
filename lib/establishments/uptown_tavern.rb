module BeerList
  module Establishments
    class UptownTavern < Establishment
      URL     = 'http://uptowntavernmpls.com/menus/'
      ADDRESS = '1400 Lagoon Ave, Minneapolis, MN 55408'

      def get_list
        beers = base_list
        beers = strip beers
        beers.reject &:empty?
      end

      def url
        URL
      end

      def address
        ADDRESS
      end

      private

      def base_list
        page.search('div.wp-tab-content-wrapper').slice(5).search('p').map &:text
      end

      def strip(beers)
        beers.map { |b| b.gsub(/\A[[:space:]]+|[[:space:]]+\z/, '') }
      end
    end
  end
end
