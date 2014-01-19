module BeerList
  module Establishments
    class LongfellowGrill < Establishment
      URL     = 'http://www.longfellowgrill.com/tapsandcans/'
      ADDRESS = '2990 W River Pkwy, Minneapolis, MN 55406'

      def get_list
        get_base_list
        remove_asterisks_and_strip
      end

      def url
        URL
      end

      def address
        ADDRESS
      end

      private

      def get_base_list
        @beers = page.search('.menu-item-title').map &:text
      end

      def remove_asterisks_and_strip
        @beers = @beers.map do |e|
          beer = e.match(/\*/) ? $` : e
          beer.gsub /\A[[:space:]]*|[[:space:]]*\z/, ''
        end
      end
    end
  end
end
