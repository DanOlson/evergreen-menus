module BeerList
  module Establishments
    class GrovelandTap < Establishment
      URL     = 'http://www.grovelandtap.com/on-tap/'
      ADDRESS = '1834 St Clair Ave, St Paul, MN 55105'

      def get_list
        base_list
        match_before_paren
      end

      def url
        URL
      end

      def address
        ADDRESS
      end

      private

      def base_list
        @beers = page.search('.menu-item-title').map &:text
      end

      def match_before_paren
        @beers = @beers.map do |b|
          name = b.match(/\(|\$/) ? $` : b
          name.gsub(/\A[[:space:]]*|[[:space:]]*\z/, '')
        end
      end
    end
  end
end
