module BeerList
  module Establishments
    class LylesLiquor < Establishment
      URL      = 'http://thriftyhipster.com/widget?options%5Btype%5D=menu&options%5Bvenue%5D=29'
      ADDRESS  = '2021 Hennepin Ave, Minneapolis, MN 55405'
      WEEKDAYS = /MONDAY|TUESDAY|WEDNESDAY|THURSDAY|FRIDAY/

      def get_list
        base_list
        remove_blue_plate_specials
      end

      def url
        URL
      end

      def address
        ADDRESS
      end

      private

      def base_list
        @beers = page.search('.menu li').map(&:text)
      end

      def remove_blue_plate_specials
        @beers = @beers.reject { |beer| beer.match WEEKDAYS }
      end
    end
  end
end
