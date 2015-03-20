module BeerList
  module Establishments
    class Pub819 < Establishment
      URL     = 'http://www.pub819.com/beer/'
      ADDRESS = '819 Main Street, Hopkins, MN 55343'

      def get_list
        beers = base_list
        beers = remove_style beers
        beers = remove_empty beers
      end

      def url
        URL
      end

      def address
        ADDRESS
      end

      private

      def remove_empty(beers)
        beers.reject { |beer| beer.match /\A[[:space:]]+\z/ }
      end

      def remove_style(beers)
        beers.map { |beer| beer.split('–')[0].strip }
      end

      def base_list
        sections.flat_map { |section| section.text.split("\n").map &:strip }
      end

      def sections
        page.search('p')[0..-5]
      end
    end
  end
end
