module BeerList
  module Establishments
    class MuddyWaters < Establishment
      URL     = 'http://muddywatersmpls.com/Beer.html'
      ADDRESS = '2933 Lyndale Ave S, Minneapolis, MN 55408'

      def get_list
        divs  = get_applicable_divs
        lists = divs.map &:text
        lists.map do |l|
          l.split("\r\n").map(&:strip).reject(&:empty?)
        end.flatten
      end

      def url
        URL
      end

      def address
        ADDRESS
      end

      private

      def get_applicable_divs
        page.search('div.graphic_textbox_layout_style_default')[7..9]
      end
    end
  end
end
