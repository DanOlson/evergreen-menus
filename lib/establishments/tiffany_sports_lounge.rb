module BeerList
  module Establishments
    class TiffanySportsLounge < Establishment
      URL     = 'http://www.beermenus.com/menu_widgets/8959'
      ADDRESS = '2051 Ford Pkwy, St Paul, MN 55116'

      def get_list
        find_beers
        reject_advertisement
        remove_extra_chars
        deduplicate
      end

      def url
        URL
      end

      def address
        ADDRESS
      end

      private

      def document
        @doc = Nokogiri::HTML parsed_response
      end

      def find_beers
        @beers = document.search('a').map &:text
      end

      def reject_advertisement
        @beers.reject! { |beer| beer.match /powered by/i }
      end

      def remove_extra_chars
        @beers.map! { |beer| beer.split("\\n").first }
      end

      def deduplicate
        @beers = @beers.uniq
      end

      def parsed_response
        page.body.split('innerHTML = ').last.gsub %r{\\}, ''
      end
    end
  end
end
