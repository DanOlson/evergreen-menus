module BeerList
  module Establishments
    class RayJsMinneapolis < Establishment
      URL     = 'http://www.ray-js.com/minneapolis/?page_id=71'
      ADDRESS = '500 Central Ave SE Minneapolis, Mn 55414'
      NAME    = "Ray-J's Minneapolis"

      def get_list
        base_list
        remove_empty
      end

      def name
        NAME
      end

      def url
        URL
      end

      def address
        ADDRESS
      end

      private

      def base_list
        @beers = page.search('#trunkWelcome p').map &:text
      end

      def remove_empty
        @beers = @beers.reject { |b| b.match /\A[[:space:]]\z/ }
      end
    end
  end
end
