module BeerList
  module Establishments
    class MuddyPig < Establishment
      URL   = 'http://muddypig.com/draft-beer/'
      ADDRESS = '162 Dale St N, St Paul, MN 55102'

      def get_list
        page.search('p[style="margin-left: 120px;"]').map &:text
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
