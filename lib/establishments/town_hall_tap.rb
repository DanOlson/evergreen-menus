module BeerList
  module Establishments
    class TownHallTap < Establishment
      URL     = 'http://www.townhalltap.com/brews/'
      ADDRESS = '4810 Chicago Ave S, Minneapolis, MN'

      def get_list
        base_list
        with_list_style
        split_on_newline
        remove_list_style
        add_guests
        add_house_brews
      end

      def url
        URL
      end

      def address
        ADDRESS
      end

      private

      def base_list
        @beers = page.search('div.brew p').map(&:text)
      end

      def with_list_style
        @beers.select! { |b| b.match /•/ }
      end

      def split_on_newline
        @beers.map! { |b| b.split("\n") }.flatten!
      end

      def remove_list_style
        @beers.map! { |b| b.gsub /•\s/, '' }
      end

      def add_guests
        guests = page.search('#brewcat-14 div.brew ul li').map &:text
        @beers += guests
      end

      def add_house_brews
        house = page.search('#brewcat-12 h4').map &:text
        @beers += house
      end
    end
  end
end
