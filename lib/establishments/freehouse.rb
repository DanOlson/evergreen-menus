module BeerList
  module Establishments
    class Freehouse < Establishment
      URL     = 'http://www.freehousempls.com/drink/'
      ADDRESS = '701 N Washington Ave, Minneapolis, MN 55401'
      MENU_SUBSECTIONS = %w(menu-freehouse-brews menu-guest-beers menu-guest-cans)

      def get_list
        base_list
        strip
        titleize
        add_freehouse_branding
      end

      def url
        URL
      end

      def address
        ADDRESS
      end

      def name
        'Freehouse Mpls'
      end

      private

      def menus
        @menus ||= page.search('.menus')
      end

      def menu_subsections
        MENU_SUBSECTIONS
      end

      def base_list
        @beers = menu_subsections.inject([]) do |ary, css_class|
          ary << menus.search(".#{css_class} .menu-item-title").map(&:text)
        end.flatten
      end

      def strip
        @beers.map! { |beer| beer.gsub /\A[[:space:]]+|[[:space:]]+\z/, '' }
      end

      def titleize
        @beers.map! &:titleize
      end

      def add_freehouse_branding
        @beers.map! do |beer|
          if freehouse_brewed? beer
            "Freehouse #{beer}"
          else
            beer
          end
        end
      end

      def freehouse_brewed?(beer)
        beer.match /\ANo\.\s\d/
      end
    end
  end
end
