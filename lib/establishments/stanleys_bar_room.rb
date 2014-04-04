module BeerList
  module Establishments
    class StanleysBarRoom < Establishment
      URL = 'http://www.stanleysbarroom.com/drinks/beer-list/'
      ADDRESS = '2500 University Ave NE, Minneapolis, MN 55418'

      def get_list
        beers = base_list
        beers = remove_blank beers
        beers
      end

      def url
        URL
      end

      def address
        ADDRESS
      end

      private

      def base_list
        page.search('.entry-content li').map(&:text)
      end

      def remove_blank(beers)
        beers.map(&:strip).reject{ |beer| beer.empty? }
      end
    end
  end
end
