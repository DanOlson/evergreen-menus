module BeerList
  module Establishments
    class CommonRootsCafe < Establishment
      URL     = 'http://commonrootscafe.com/menu/'
      ADDRESS = '2558 Lyndale Ave S, Minneapolis, MN 55405'

      def get_list
        breweries.zip(beer_names).map { |ary| ary.join " " }
      end

      def url
        URL
      end

      def address
        ADDRESS
      end

      private

      def beer_section
        @beer_section ||= page.search("//div[starts-with(@class, 'menu menu--beer-wine')]").search('.menu-section')[0]
      end

      def breweries
        beer_section.search('.menu-item-title').map { |t| t.text.strip.titleize }
      end

      def beer_names
        beer_section.search('.menu-item-description').map { |t| t.text.titleize }
      end
    end
  end
end
