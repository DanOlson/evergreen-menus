module BeerList
  module Establishments
    class TheNewsRoom < Establishment
      URL     = 'http://thenewsroommpls.com/catering.aspx'
      ADDRESS = '990 Nicollet Mall Minneapolis, MN 55403'

      def get_list
        base_list
        remove_trailing_comma
        titleize
        caps_ipa
        strip
      end

      def url
        URL
      end

      def address
        ADDRESS
      end

      private

      def base_list
        @beers = page.search('span.Body_copy_lunch strong').map(&:text)
      end

      def remove_trailing_comma
        @beers.map! { |beer| beer.gsub /\s?,\s?\z/, '' }
      end

      def titleize
        @beers.map! &:titleize
      end

      def caps_ipa
        @beers.map! do |beer|
          beer.gsub 'Ipa', 'IPA'
        end
      end

      def strip
        @beers.map! &:strip
      end
    end
  end
end
