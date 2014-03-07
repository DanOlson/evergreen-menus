module BeerList
  module Establishments
    class CrookedPint < Establishment
      URL     = 'http://crookedpint.com/minneapolis/drinks/beer'
      ADDRESS = '501 Washington Ave S, Minneapolis, MN 55415'

      def get_list
        page.search('.item-page li').map &:text
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
