module BeerList
  module Establishments
    class CrookedPint < Establishment
      URL     = 'http://crookedpint.com/minneapolis/drinks/beer'
      ADDRESS = '501 Washington Ave S, Minneapolis, MN 55415'

      def get_list
        beers = base_list
        beers = remove_volume beers
        beers = remove_empty beers
      end

      def url
        URL
      end

      def address
        ADDRESS
      end

      private

      def base_list
        page.search('.g1-column li').map &:text
      end

      def remove_volume(beers)
        beers.map do |beer|
          if beer.match(/\(/)
            $`
          else
            beer
          end
        end
      end

      def remove_empty(beers)
        beers.reject &:empty?
      end
    end
  end
end
