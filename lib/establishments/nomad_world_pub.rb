module BeerList
  module Establishments
    class NomadWorldPub < Establishment
      URL      = 'http://www.nomadworldpub.com/beer.php'
      ADDRESS  = '501 Cedar Ave, Minneapolis, MN 55454'
      HEADINGS = /BOTTLES AND CANS|ON TAP|FROM THE CELLAR|TALL BOYS|NON-ALCOHOLIC/

      def get_list
        base_list
        split_text
        reject_headings
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
        @beers = page.search('div#tap,div#bottles').map(&:text)
      end

      def split_text
        @beers.map! { |beer| beer.split "\r\n" }.flatten!
      end

      def reject_headings
        @beers.reject! { |beer| beer.match HEADINGS }
      end

      def strip
        @beers = @beers.map { |beer| beer.sub /[[:space:]]*\z/, '' }
      end
    end
  end
end
