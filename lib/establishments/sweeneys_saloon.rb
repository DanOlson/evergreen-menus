module BeerList
  module Establishments
    class SweeneysSaloon < Establishment
      URL     = 'http://www.sweeneyssaloon.com//'
      ADDRESS = '96 Dale St N, St Paul, MN 55102'
      NAME    = "Sweeney's Saloon"

      def get_list
        page.search('#beerlist .beer').map(&:text)
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
