module BeerList
  module Establishments
    class BulldogLowertown < Establishment
      URL     = 'http://www.thebulldoglowertown.com/beer/'
      ADDRESS = '237 E 6th St, St Paul, MN 55101'

      def get_list
        base_list
        match_before_paren
      end

      def base_list
        @beers = page.search('ul.beer_logos > li > p[style="text-align: left;"]').map(&:text)
      end

      def match_before_paren
        @beers = @beers.map { |b| b.match(/\(/) ? $`.gsub(/\A[[:space:]]*|[[:space:]]*\z/, '') : b }
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
