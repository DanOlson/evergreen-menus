module BeerList
  module Establishments
    class HammerAndSickle < Establishment
      URL     = 'http://www.hammerandsicklempls.com/'
      ADDRESS = '1300 Lagoon Ave. S. Suite 150 Minneapolis, MN 55113'

      def get_list
        base_list
        titleize
        fix_ipa_and_pbr
      end

      def url
        URL
      end

      def address
        ADDRESS
      end

      private

      def base_list
        lists = page.search('#gallery .span6').first.search('.menu-section').reverse.take(2)
        bottle_list, tap_list = lists
        tap_list = tap_list.search('h4').map &:text
        bottle_list = bottle_list.search('.span11').map { |e| e.text.strip }
        @beers = tap_list + bottle_list
      end

      def titleize
        @beers = @beers.map &:titleize
      end

      def fix_ipa_and_pbr
        @beers = @beers.map { |beer| beer.sub('Ipa', 'IPA') }
      end
    end
  end
end
