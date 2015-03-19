module BeerList
  module Establishments
    class GrayHouse < Establishment
      URL     = 'http://thegrayhouseeats.com/the-sips/'
      ADDRESS = '610 W Lake St, Minneapolis, MN 55408'
      NAME    = 'The Gray House'

      def get_list
        beer_list_div.map &:text
      end

      def name
        NAME
      end

      def url
        URL
      end

      def address
        ADDRESS
      end

      private

      def beer_list_div
        page.search('.one_third').first
      end
    end
  end
end
