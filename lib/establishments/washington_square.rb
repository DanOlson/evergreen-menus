module BeerList
  module Establishments
    class WashingtonSquare < Establishment
      URL     = 'http://washingtonsquareonline.net/as_tap%20beer'
      ADDRESS = '4736 Washington Ave, St Paul, MN 55110'

      def get_list
        base_list
        split_on_newline
        remove_escape_chars
        remove_nbsp
      end

      def url
        URL
      end

      def address
        ADDRESS
      end

      private

      def base_list
        @results = page.search('p strong').map(&:text)
      end

      def split_on_newline
        @results = @results.map { |beer| beer.split "\n" }.flatten
      end

      def remove_escape_chars
        @results.map! { |beer| beer.gsub /\A[[:space:]]+|[[:space:]]+\z/, '' }
      end

      def remove_nbsp
        @results = @results.map{ |b| b.gsub(/[[:space:]]{2,}/, '') }
      end
    end
  end
end
