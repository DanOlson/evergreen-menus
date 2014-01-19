module BeerList
  module Establishments
    class CrookedPint < Establishment
      URL     = 'http://crookedpint.com/the-bar'
      ADDRESS = '501 Washington Ave S, Minneapolis, MN 55415'

      def get_list
        beer_list_div.search('ul.check li').map &:text
      end

      def url
        URL
      end

      def address
        ADDRESS
      end

      private

      def beer_list_div
        page.search('div.text-article > div').slice(1)
      end
    end
  end
end
