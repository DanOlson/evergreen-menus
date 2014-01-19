module BeerList
  module Establishments
    class ThreeSquares < Establishment
      URL     = 'http://www.3squaresrestaurant.com/taps-cans/'
      ADDRESS = '12690 Arbor Lakes Pkwy N, Maple Grove, Minnesota 55369'

      def get_list
        base_list
        match_before_paren
        strip
      end

      def url
        URL
      end

      def address
        ADDRESS
      end

      private

      def base_list
        @beers = page.search('.menu-item-title').map &:text
      end

      def match_before_paren
        @beers = @beers.map { |b| b.match(/\(/) ? $` : b }
      end

      def strip
        @beers = @beers.map { |beer| beer.gsub(/\A[[:space:]]*|[[:space:]]*\z/, '') }
      end
    end
  end
end
