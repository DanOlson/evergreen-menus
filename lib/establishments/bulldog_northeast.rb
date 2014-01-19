module BeerList
  module Establishments
    class BulldogNortheast < Establishment
      URL     = 'http://www.thebulldognortheast.com/beer/'
      ADDRESS = '401 E Hennepin Ave, Minneapolis, MN 55414'

      def get_list
        base_list
        extract_comma_separated_items
        strip
        remove_headings
        @beers
      end

      def base_list
        @beers = page.search('.item h2').map(&:text)
      end

      def extract_comma_separated_items
        @beers = @beers.map { |beer| beer.split(',') }.flatten
      end

      def strip
        @beers.map! &:strip
      end

      def remove_headings
        @beers.shift 2
      end

      def url
        URL
      end

      def address
        ADDRESS
      end
    end
  end
end
