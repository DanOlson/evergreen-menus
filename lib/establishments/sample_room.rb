module BeerList
  module Establishments
    class SampleRoom < Establishment
      URL     = 'http://the-sample-room.com/menus/beer'
      ADDRESS = '2124 Marshall St NE, Minneapolis, MN 55418'

      def get_list
        base_list
        remove_prices
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
        @beers = beer_section.map { |node| node.text.split "\n" }.flatten
      end

      def remove_prices
        @beers = @beers.map { |beer| beer.match(/\$/) ? $` : nil }.compact
      end

      def strip
        @beers = @beers.map &:strip
      end

      def beer_section
        @beer_section ||= page.search('.text p')[1..3]
      end
    end
  end
end
