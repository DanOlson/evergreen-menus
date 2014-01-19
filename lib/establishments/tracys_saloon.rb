module BeerList
  module Establishments
    class TracysSaloon < Establishment
      URL     = 'http://www.tracyssaloon.com/beer.html'
      ADDRESS = '2207 E Franklin Ave, Minneapolis, MN 55404'

      def get_list
        page.search('span.fooditem').map(&:text)
      end

      def url
        URL
      end

      def address
        ADDRESS
      end

      def name
        "Tracy's Saloon"
      end
    end
  end
end
