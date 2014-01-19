module BeerList
  module Establishments
    class RailStation < Establishment
      URL     = 'http://www.railstationbarandgrill.com/rail-station-craft-beer-list/'
      ADDRESS = '3675 Minnehaha Avenue Minneapolis, MN 55406'

      def get_list
        base_list
        extract_multi
        match_before_paren_or_hyphen
        expand_multi
        add_multi
      end

      def url
        URL
      end

      def address
        ADDRESS
      end

      private

      def base_list
        @beers = page.search('div#main li').map(&:text)
      end

      def extract_multi
        @multi, @beers = @beers.partition { |b| b.start_with? "(" }
      end

      def match_before_paren_or_hyphen
        @beers.map! { |b| b.match(/\(|–/) ? $`.strip : b }
      end

      def expand_multi
        @multi.map! do |m|
          base, options = m.split("–")
          base = base.gsub(/\(\d\)/, '').strip
          options.split(',').map{ |o| base + o }
        end
        @multi.flatten!
      end

      def add_multi
        @beers += @multi
      end
    end
  end
end
