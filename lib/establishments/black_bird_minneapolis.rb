module BeerList
  module Establishments
    class BlackBirdMinneapolis < Establishment
      URL     = 'http://www.blackbirdmpls.com/beer-wine/'
      ADDRESS = '3800 Nicollet Ave, Minneapolis, MN 55409'
      NAME    = 'Blackbird'

      def get_list
        menu_item_titles
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

      def menu_sections
        page.search('.menu-section')[1..2]
      end

      def menu_item_titles
        menu_sections.search('.menu-item-title').map do |title|
          title.text.strip.titleize
        end
      end
    end
  end
end
