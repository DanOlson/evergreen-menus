module BeerList
  module Establishments
    class NewBohemia < Establishment
      URL     = 'http://www.newbohemiausa.com/bier/'
      ADDRESS = '233 E Hennepin Ave, Minneapolis, MN 55414'
      CRUFT   = /\s\(Gluten free\) 5.8/
      LOCAL_DRAFTS     = 'Local Drafts'
      REGIONAL_DRAFTS  = 'Regional & International Drafts'
      BOTTLES_AND_CANS = 'Bottles & Cans'
      SOCIAL_BOTTLES   = 'Social Bottles'

      def get_list
        @beers = base_list
        remove_cruft
        strip
        fix_surly_abrasive
        @beers
      end

      def url
        URL
      end

      def address
        ADDRESS
      end

      private

      def base_list
        beers = split_on_newline raw_list
        match_before_slash(beers).compact
      end

      def remove_cruft
        @beers = @beers.map { |beer| beer.sub CRUFT, '' }
      end

      def strip
        @beers = @beers.map { |beer| beer.gsub(/\A\W*|\W*\z/, '') }
      end

      ###
      # FIXME. This is gross. Should be replaced with some sort of
      # canonical list and pattern matching.
      def fix_surly_abrasive
        @beers = @beers.map { |b| b.sub 'Sulry', 'Surly' }
      end

      def raw_text
        @raw_text ||= page.search('div.entry-content p').map &:text
      end

      def raw_list
        local_drafts     = raw_text[menu_section_index LOCAL_DRAFTS]
        regional_drafts  = raw_text[menu_section_index REGIONAL_DRAFTS]
        bottles_and_cans = raw_text[menu_section_index BOTTLES_AND_CANS]
        social_bottles   = raw_text[menu_section_index SOCIAL_BOTTLES]
        [local_drafts, regional_drafts, bottles_and_cans, social_bottles]
      end

      def menu_section_index(section)
        raw_text.index(section) + 1
      end

      def split_on_newline(beers)
        beers.inject([]) { |ary, string| ary << string.split("\n") }.flatten
      end

      def match_before_slash(beers)
        beers.map { |beer| beer.match(/\A([^\/]+)\/{1}/); $1 }
      end
    end
  end
end
