module BeerList
  module Establishments
    class BoulderTapHouseMankato < Establishment
      URL     = 'http://www.bouldertaphouse.com/mankato-mn/show-me-some-beer/'
      ADDRESS = '291 St Andrews Dr, Mankato, MN 56001'

      def get_list
        base_list
        match_before_paren
        reject_empty
        reject_bad_results
      end

      def url
        URL
      end

      def address
        ADDRESS
      end

      private

      def base_list
        @beers = page.search('p b:first-child').map(&:text)
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

      def reject_bad_results
        @beers = @beers.reject do |beer|
          beer.match /\ACOMING\sSOON|\A\$\d|\AAs\sseen\son\sTap/
        end
      end

      def reject_empty
        @beers = @beers.reject &:empty?
      end
    end
  end
end
