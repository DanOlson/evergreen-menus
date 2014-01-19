module BeerList
  module Establishments
    class EdinaGrill < Establishment
      URL     = 'http://www.edinagrill.com/current-tap-list'
      ADDRESS = '5028 France Ave S, Edina, MN 55424'

      def get_list
        page.search('.menu-item-title').map { |el| el.text.strip }
      end

      def url
        URL
      end

      def address
        ADDRESS
      end
    end
  end
end
