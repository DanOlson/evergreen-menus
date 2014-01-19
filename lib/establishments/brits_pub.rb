module BeerList
  module Establishments
    class BritsPub < Establishment
      URL     = 'http://britspub.com/menu/index.php?strWebAction=menu_detail&intMenuID=2'
      ADDRESS = '1110 Nicollet Mall, Minneapolis, MN 55403'

      def get_list
        base_list
        only_take_beers
        split_mashups
        strip_whitespace
      end

      def url
        URL
      end

      def address
        ADDRESS
      end

      private

      def base_list
        @beers = page.search('.textStandard').map { |x| x.text.strip }
      end

      def only_take_beers
        @beers.select! { |beer| beer.match /\(/ }
      end

      def split_mashups
        @beers = @beers.map { |beer| beer.split ")" }.flatten.map { |beer| beer.match /\s?\(/; $`.titleize }
      end

      def strip_whitespace
        @beers = @beers.map { |beer| beer.gsub /\A[[:space:]]+|[[:space:]]+\z/, '' }
      end
    end
  end
end
