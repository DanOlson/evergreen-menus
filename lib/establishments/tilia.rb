module BeerList
  module Establishments
    class Tilia < Establishment
      URL     = 'http://www.tiliampls.com/menu/beer-menu/'
      ADDRESS = '2726 W 43rd St, Minneapolis, MN 55410'

      def get_list
        base_list
        format_results
      end

      def url
        URL
      end

      def address
        ADDRESS
      end

      private

      def base_list
        @beers = page.search('p strong').map(&:text)
      end

      def format_results
        @beers.map! do |beer|
          beer.split(' – ').reverse.join ' '
        end
      end
    end
  end
end
