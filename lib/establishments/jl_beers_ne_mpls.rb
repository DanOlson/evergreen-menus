module BeerList
  module Establishments
    class JLBeersNeMpls < Establishment
      URL     = 'http://jlbeers.com/nempls/beers/tap-beers/'
      ADDRESS = '24 University Ave NE Suite 100, Minneapolis, MN 55413'
      NAME    = 'JL Beers'

      def get_list
        breweries = get_breweries
        beers     = get_beers
        breweries.zip(beers).map { |b| b.map(&:strip).join(' ') }
      end

      def url
        URL
      end

      def address
        ADDRESS
      end

      def name
        NAME
      end

      private

      def get_breweries
        beer_list_element.search('.brewery').map { |e| e.text.titleize }
      end

      def get_beers
        beer_list_element.search('.beer').map { |e| e.text.titleize }
      end

      def beer_list_element
        page.search('.beer-list')
      end
    end
  end
end
