module BeerList
  module Establishments
    class Ward6 < Establishment
      URL     = 'http://ward6stpaul.com/content/draft-beer'
      ADDRESS = '858 Payne Ave, St Paul, MN 55130'

      def get_list
        beers = base_list
        beers = strip beers
        beers.reject &:empty?
      end

      def url
        URL
      end

      def address
        ADDRESS
      end

      private

      def base_list
        page.search('h3 strong').map &:text
      end

      def strip(beers)
        beers.map { |b| b.gsub(/\A[[:space:]]+|[[:space:]]+\z/, '') }
      end
    end
  end
end
