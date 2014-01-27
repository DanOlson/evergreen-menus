module BeerList
  module Establishments
    class StubAndHerbs < Establishment
      URL     = 'http://www.stubandherbsbar.com/Taps.html'
      ADDRESS = '227 SE Oak St, Minneapolis, MN 55455'

      def get_list
        base_list
        remove_not_beers
        remove_html_format
      end

      def url
        URL
      end

      def address
        ADDRESS
      end

      private

      def base_list
        @beers = page.links_with(text: '').map &:href
      end

      def remove_not_beers
        @beers.reject! { |beer| beer.match /Page5|\.pdf/ }
      end

      def remove_html_format
        @beers.map! { |beer| beer.gsub('.html', '') }
      end
    end
  end
end
