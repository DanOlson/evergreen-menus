module BeerList
  module Establishments
    class BulldogDowntown < Establishment
      URL     = 'http://thebulldogdowntown.com/beer-wine/'
      ADDRESS = '1111 Hennepin Ave, Minneapolis, MN 55403'

      def get_list
        base_list
        remove_wines
        remove_extra_data
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
        @beers = page.search('.beer_logos li').map &:text
      end

      def remove_wines
        @beers.reject! { |beer| beer.match /Glass:/ }
      end

      ###
      # Take the string before ( or $. Removes origin and price.
      def remove_extra_data
        @beers = @beers.map do |beer|
          beer.match(/\(|\$/) ? $` : beer
        end
      end

      def strip
        @beers = @beers.map &:strip
      end
    end
  end
end
