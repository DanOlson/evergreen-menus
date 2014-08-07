module BeerList
  module Establishments
    class FabulousFerns < Establishment
      URL     = 'http://fabulousferns.com/wines-beers-and-more/'
      ADDRESS = '400 Selby Ave, St Paul, MN 55102'
      SCOTCH  = '- SCOTCH -'
      BEERS   = '- BEERS -'
      REJECTS = [
        'TAP BEERS',
        'BOTTLED BEER',
        'BEER FLIGHTS  '
      ]

      def get_list
        beers = base_list
        beers = cull_to_beers_only beers
        beers = remove_rejects beers
        beers = remove_empty beers
      end

      def url
        URL
      end

      def address
        ADDRESS
      end

      def base_list
        page.search('p > strong').map(&:text)
      end

      def cull_to_beers_only(beers)
        the_beginning = beers.index(BEERS) + 1
        the_end = beers.index SCOTCH
        beers[the_beginning...the_end]
      end

      def remove_rejects(beers)
        beers.reject { |b| REJECTS.include? b }
      end

      def remove_empty(beers)
        beers.reject &:empty?
      end
    end
  end
end
