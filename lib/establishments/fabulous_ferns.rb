module BeerList
  module Establishments
    class FabulousFerns < Establishment
      URL     = 'http://fabulousferns.com/beer'
      ADDRESS = '400 Selby Ave, St Paul, MN 55102'

      def get_list
        page.search('p.fdm-item-title').map(&:text)
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
