module BeerList
  module Establishments
    class TBox < Establishment
      URL     = 'http://www.tboxbarandgrill.com/now-on-tap'
      ADDRESS = '1431 147th Ave NE, Ham Lake, MN 55304'

      def get_list
        get_tables.inject([]) do |ary, t|
          ary << extract_text_from_applicable_tds(t)
        end.flatten
      end

      def url
        URL
      end

      def address
        ADDRESS
      end

      private

      def get_tables
        page.search('tbody')
      end

      def extract_text_from_applicable_tds(table)
        data = table.search('tr').slice(1, 2).inject([]) do |ary, tr|
          ary << tr.search('td').map(&:text)
        end
        build_names_from_applicable_data data
      end

      def build_names_from_applicable_data(data)
        brewers = strip_whitespace data[0]
        names   = strip_whitespace data[1]
        brewers.zip(names).map { |ary| ary.join ' ' }
      end

      def strip_whitespace(array)
        array.map{ |a| a.gsub /\A[[:space:]]*|[[:space:]]*\z/, '' }
      end
    end
  end
end
