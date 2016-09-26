module BeerList
  module Establishments
    class BritsPub < Establishment
      URL     = 'http://britspub.com/menu/'
      ADDRESS = '1110 Nicollet Mall, Minneapolis, MN 55403'

      def get_list
        list = base_list
        list = remove_location list
        format list
      end

      def url
        URL
      end

      def address
        ADDRESS
      end

      private

      def format(list)
        list.map { |beer| beer.titleize }
      end

      def remove_location(list)
        list.map { |beer| beer.match(/^(.*)\(/).captures[0] }
      end

      def base_list
        beer_menu.map { |x| x.text.strip }
      end

      def beer_menu
        page.search('[class*="menu-draught-beer"] .menu-item-title')
      end
    end
  end
end
