module BeerList
  module Establishments
    class ButcherAndTheBoar < Establishment
      URL     = 'https://widget.locu.com/widget2/locu.widget.v2.0.js?id=9591f6059bf1a900ab3c&medium=web'
      ADDRESS = '1121 Hennepin Ave, Minneapolis, MN 55403'

      def get_list
        beer_menu.search('.locu-menu-item-name').map &:text
      end

      def url
        URL
      end

      def address
        ADDRESS
      end

      private

      def beer_menu
        doc.search('.locu-menus .locu-menu')[1]
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
