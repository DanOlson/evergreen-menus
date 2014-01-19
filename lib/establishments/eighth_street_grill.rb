module BeerList
  module Establishments
    class EighthStreetGrill < Establishment
      URL     = 'http://8thstreetgrill.com/beer-selection-winter/'
      ADDRESS = '800 Marquette Ave S #107, Minneapolis, MN 55402'

      def get_list
        base_list
        match_before_paren
      end

      def url
        URL
      end

      def address
        ADDRESS
      end

      private

      def base_list
        @beers = page.search('div.one_half li').map(&:text)
      end

      def match_before_paren
        @beers = @beers.map do |beer|
          if beer.match /\(/
            $`.strip
          else
            beer.strip
          end
        end
      end
    end
  end
end
