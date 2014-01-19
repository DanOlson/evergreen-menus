module BeerList
  module Establishments
    class NewBohemia < Establishment
      URL     = 'http://www.newbohemiausa.com/bier/'
      ADDRESS = '233 E Hennepin Ave, Minneapolis, MN 55414'
      CRUFT   = /Regional & International Drafts|\s\(Gluten free\) 5.8/

      def get_list
        @beers = base_list
        remove_cruft
        strip
      end

      def url
        URL
      end

      def address
        ADDRESS
      end

      private

      def base_list
        beers = split_on_newline raw_text
        match_before_slash(beers).compact
      end

      def remove_cruft
        @beers = @beers.map { |beer| beer.sub CRUFT, '' }
      end

      def strip
        @beers = @beers.map { |beer| beer.gsub(/\A\W*|\W*\z/, '') }
      end

      def raw_text
        page.search('div.entry-content p')[7..9].map(&:text).flatten
      end

      def split_on_newline(beers)
        beers.inject([]) { |ary, string| ary << string.split("\n") }.flatten
      end

      def match_before_slash(beers)
        beers.map { |beer| beer.match(/\A([^\/]+)\/{1}/); $1 }
      end
    end
  end
end
