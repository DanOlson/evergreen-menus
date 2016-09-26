module BeerList
  module Establishments
    class BritsPub < Establishment
      URL     = 'http://britspub.com/menu/'
      ADDRESS = '1110 Nicollet Mall, Minneapolis, MN 55403'

      def get_list
        beer_menu.map { |x| x.text.strip }
      end

      def url
        URL
      end

      def address
        ADDRESS
      end

      private

      def beer_menu
        page.search('[class*="menu-draught-beer"] .menu-item-title')
      end
    end
  end
end
