module BeerList
  module Establishments
    class PigAndFiddle < Establishment
      URL     = 'http://www.pignfiddle.com/beer'
      NAME    = 'Pig & Fiddle'
      ADDRESS = '3812 W 50th St, Minneapolis, MN 55410'

      TITLES  = [
        'Pale Ales / IPAs',
        'Pilsner/Lager',
        'Cider',
        'Amber',
        'Bock',
        'Brown',
        'Red',
        'Scotch Ale',
        'Winter Warmer',
        'Porter / Stout',
        'Belgian & Belgian-Style',
        'Wheat',
        'Belgian Pale',
        'Strong Ale',
        'Fruit'
      ]

      def get_list
        base_list
        remove_trailing_comma
        remove_blanks
        remove_styles
        remove_title
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

      def base_list
        @beers = page.search('p strong').map { |node| node.text.strip }
      end

      def remove_trailing_comma
        @beers = @beers.map do |beer|
          beer.match(/,\z/) ? $` : beer
        end
      end

      def remove_styles
        @beers = @beers.reject do |beer|
          titles.include? beer
        end
      end

      def remove_blanks
        @beers = @beers.reject do |beer|
          beer.to_s.empty? || beer == '/'
        end
      end

      def remove_title
        @beers = @beers.reject { |beer| !!beer.match(/\ADraft Beer/) }
      end

      def titles
        TITLES
      end
    end
  end
end
