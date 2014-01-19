module BeerList
  module Establishments
    class PigAndFiddle < Establishment
      URL     = 'http://pignfiddle.com/beer'
      NAME    = 'Pig & Fiddle'
      ADDRESS = '3812 W 50th St, Minneapolis, MN 55410'

      def get_list
        page.search('tr').map { |node| node.text.strip }
      end

      def url
        URL
      end

      def address
        ADDRESS
      end

      def name
        NAME
      end
    end
  end
end
