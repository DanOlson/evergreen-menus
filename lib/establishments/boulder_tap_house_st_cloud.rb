module BeerList
  module Establishments
    class BoulderTapHouseStCloud < Establishment
      URL     = 'http://www.bouldertaphouse.com/st-cloud-mn/show-me-some-beer/'
      ADDRESS = '3950 2nd St S, St Cloud, MN 56301'
      NEW_TO_LIST = 'New to list'

      def get_list
        base_list
        match_before_paren
        remove_asterisks
        remove_empty
        remove_new_to_list
      end

      def url
        URL
      end

      def address
        ADDRESS
      end

      private

      def base_list
        @beers = page.search('b').map(&:text)
      end

      def match_before_paren
        @beers = @beers.map do |beer|
          if beer.match /\(/
            $`.strip
          else
            beer.strip
          end
        end
      end

      def remove_asterisks
        @beers = @beers.map do |beer|
          beer.sub /^\*/, ''
        end
      end

      def remove_new_to_list
        @beers.reject! { |b| b.match NEW_TO_LIST }
      end

      def remove_empty
        @beers.reject! { |b| b.match(/\A\W\z/) || b.empty? }
      end
    end
  end
end
