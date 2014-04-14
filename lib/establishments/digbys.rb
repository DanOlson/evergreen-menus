module BeerList
  module Establishments
    class Digbys < Establishment
      URL     = 'http://eatdigbys.com/on-tap/'
      ADDRESS = 'Center St, St Paul, MN 55113'
      NAME    = "Digby's"

      def get_list
        beers = base_list
        beers = remove_state_of_origin beers
      end

      def name
        NAME
      end

      def url
        URL
      end

      def address
        ADDRESS
      end

      private

      def base_list
        page.search('.menu-title').map &:text
      end

      def remove_state_of_origin(beers)
        beers.map { |b| b.split(' - ').first }
      end
    end
  end
end
