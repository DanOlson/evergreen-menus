module BeerList
  module Establishments
    class MotoI < Establishment
      URL     = 'https://widget.locu.com/widget2/locu.widget.v2.0.js?id=ccb76a197af00c1606fd&medium=web'
      ADDRESS = '2940 Lyndale Ave S, Minneapolis, MN 55408'
      NAME    = 'Moto-I'

      def get_list
        beer_menu.search('.locu-menu-item-name').map &:text
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

      def beer_menu
        bar_menu.search('.locu-subsection')[6]
      end

      def bar_menu
        doc.search('.locu-menu')[2]
      end

      def doc
        Nokogiri::HTML(parsed_response) { |config| config.nonet }
      end

      def parsed_response
        page.content.split("html\":").last.split(",\"debug\":false").first.gsub %r{\\}, ''
      end
    end
  end
end
