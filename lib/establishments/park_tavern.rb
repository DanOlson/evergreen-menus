module BeerList
  module Establishments
    class ParkTavern < Establishment
      URL     = 'http://parktavern.net/drink/beer'
      ADDRESS = '3401 Louisiana Ave S St Louis Park, MN 55426'

      def get_list
        beers = base_list
        beers = strip beers
        beers = reject_empty beers
        beers = match_before_paren beers
        beers.uniq
      end

      def url
        URL
      end

      def address
        ADDRESS
      end

      private

      def strip(beers)
        beers.map { |b| b.gsub(/\A[[:space:]]+|[[:space:]]+\z/, '') }
      end

      def base_list
        @beers = page.search('p.p1').map(&:text).map &:strip
      end

      def reject_empty(beers)
        beers.select { |b| b.match /\w/ }
      end

      def match_before_paren(beers)
        beers.map { |b| b.match(/\(/) ? $`.strip : b }
      end
    end
  end
end
