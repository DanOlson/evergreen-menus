module BeerList
  module Establishments
    class SevenWestTaphouse < Establishment
      URL     = 'http://7westtaphouse.com/index.php?option=com_content&view=article&id=46&Itemid=114'
      ADDRESS = '7 W Superior St, Duluth, MN 55802'

      def get_list
        base_list
        match_before_state_and_abv
        add_nitros
      end

      def url
        URL
      end

      def address
        ADDRESS
      end

      def name
        '7 West Taphouse'
      end

      private

      def base_list
        @beers = page.search('.custombox3 p').map(&:text)
      end

      def match_before_state_and_abv
        @beers = @beers.map { |beer| beer.match /\s?[A-Z]{0,2}\s?\d+\.?\d*%/; $` }.compact
      end

      def add_nitros
        nitros = page.search('.item-page h4').map &:text
        @beers += nitros
      end
    end
  end
end
