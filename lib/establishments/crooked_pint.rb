module BeerList
  module Establishments
    class CrookedPint < Establishment
      URL     = 'http://www.crookedpint.com/downtown-minneapolis/drinks/'
      ADDRESS = '501 Washington Ave S, Minneapolis, MN 55415'

      def get_list
        beers = base_list
        beers = get_names beers
      end

      def url
        URL
      end

      def address
        ADDRESS
      end

      private

      def base_list
        page.search('li.g1-three-fifth p').first.text.split("\n")
      end

      def get_names(beers)
        beers.map do |beer|
          beer.split('•')[0].strip
        end
      end
    end
  end
end
