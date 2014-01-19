module BeerList
  module Establishments
    class BlackBirdMinneapolis < Establishment
      URL     = 'http://www.blackbirdmpls.com/search/label/beerwine'
      ADDRESS = '3800 Nicollet Ave, Minneapolis, MN 55409'
      NAME    = 'Blackbird'

      def get_list
        base_list
        split_on_newline
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

      private

      def base_list
        text   = page.search('.entry-content').map(&:text).join
        @beers = text.split("Sparkling & Rose").first.split("Bottles & Cans").last
      end

      def split_on_newline
        @beers = @beers.split("\n").map(&:strip).reject &:empty?
      end
    end
  end
end
