module BeerList
  module Establishments
    class Ward6 < Establishment
      URL     = 'http://ward6stpaul.com/content/draft-beer'
      ADDRESS = '858 Payne Ave, St Paul, MN 55130'

      def get_list
        page.search('h3 strong').map &:text
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
