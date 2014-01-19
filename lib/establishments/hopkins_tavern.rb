module BeerList
  module Establishments
    class HopkinsTavern < Establishment
      URL     = 'http://www.hopkinstavern.com/drink/'
      ADDRESS = '819 Main Street, Hopkins, MN 55343'

      def get_list
        base_list
        match_before_hyphen
      end

      def url
        URL
      end

      def address
        ADDRESS
      end

      private

      def base_list
        @beers = page.search('.entry ol')[0..1].search('li').map &:text
      end

      def match_before_hyphen
        @beers = @beers.map { |b| b.split('–').first.strip }
      end
    end
  end
end
