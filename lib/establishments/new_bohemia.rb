module BeerList
  module Establishments
    class NewBohemia < Establishment
      URL     = 'http://www.newbohemiausa.com/bier/'
      ADDRESS = '233 E Hennepin Ave, Minneapolis, MN 55414'
      CRUFT   = /\s\(Gluten free\) 5.8/
      LOCAL_DRAFTS    = 'Local Drafts'
      REGIONAL_DRAFTS = 'Regional Drafts'
      TALLBOYS        = 'Tallboys'
      SOCIAL_BOTTLES  = 'Social Bottles'
      FLIGHTS         = 'Flights'

      def get_list
        beers = base_list
        beers = remove_cruft beers
        beers = strip beers
        beers
      end

      def url
        URL
      end

      def address
        ADDRESS
      end

      private

      def base_list
        beers = raw_list
        match_before_slash(beers).compact
      end

      def remove_cruft(beers)
        beers.map { |beer| beer.sub CRUFT, '' }
      end

      def strip(beers)
        beers.map { |beer| beer.gsub(/\A\W*|\W*\z/, '') }
      end

      def raw_text
        @raw_text ||= page.search('div.entry-content p').map &:text
      end

      def raw_list
        [local_drafts, regional_drafts, tallboys, social_bottles].reduce :+
      end

      def local_drafts
        beers_between_sections LOCAL_DRAFTS, REGIONAL_DRAFTS
      end

      def regional_drafts
        beers_between_sections REGIONAL_DRAFTS, FLIGHTS
      end

      def tallboys
        beers_between_sections TALLBOYS, SOCIAL_BOTTLES
      end

      def social_bottles
        split_on_newline raw_text[menu_section_index SOCIAL_BOTTLES]
      end

      def beers_between_sections(sec1, sec2)
        raw_text[(menu_section_index(sec1))..(raw_text.index(sec2) - 1)]
      end

      def menu_section_index(section)
        raw_text.index(section) + 1
      end

      def split_on_newline(str)
        str.split("\n")
      end

      def match_before_slash(beers)
        beers.map { |beer| beer.match(/\A([^\/]+)\/{1}/); $1 }
      end
    end
  end
end
