module BeerList
  module Establishments
    class MuddyPig < Establishment
      URL     = 'http://muddypig.com/draft-beer/'
      ADDRESS = '162 Dale St N, St Paul, MN 55102'

      def get_list
        beers = base_list
        beers = remove_nbsp beers
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
        page.search('.sqs-block-content h1 ~ p').map &:text
      end

      def remove_nbsp(beers)
        beers.map { |b| b.gsub(/\A[[:space:]]+|[[:space:]]+\z/, '') }
      end
    end
  end
end
