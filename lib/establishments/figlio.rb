module BeerList
  module Establishments
    class Figlio < Establishment
      URL     = 'http://figlio.com/west-end-happy-hour/beer-list/'
      ADDRESS = '5331 W 16th St, Minneapolis, MN 55416'
      BARTENDERS_PICK = 'Bartender’s Pick'

      def get_list
        base_list.reject { |beer| beer == BARTENDERS_PICK }
      end

      def url
        URL
      end

      def address
        ADDRESS
      end

      private

      def base_list
        page.search('#beer-list strong').map { |node| node.text.titleize }
      end
    end
  end
end
