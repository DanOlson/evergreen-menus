module BeerList
  module Establishments
    class LowryUptown < Establishment
      URL     = 'http://www.thelowryuptown.com/drink'
      ADDRESS = '2112 Hennepin Ave, Minneapolis, MN 55405'

      def get_list
        base_list
        strip
        reject_updated
      end

      def url
        URL
      end

      def address
        ADDRESS
      end

      private

      def base_list
        @beers = taps + tall_boys
      end

      def taps
        page.search('.menu-on-tap .menu-item-title').map &:text
      end

      def tall_boys
        page.search('.menu-tall-boys .menu-item-title').map &:text
      end

      def strip
        @beers = @beers.map { |beer| beer.gsub(/\A\W*|\W*\z/, '') }
      end

      def reject_updated
        @beers = @beers.reject { |beer| !!beer.match(/Updated/) }
      end
    end
  end
end
