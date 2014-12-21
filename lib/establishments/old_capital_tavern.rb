module BeerList
  module Establishments
    class OldCapitalTavern < Establishment
      URL     = 'http://www.oldcapitaltavern.com/beer.php'
      ADDRESS = '2 North Benton Drive, Sauk Rapids, MN 56379'

      def get_list
        table = page.search('table')[0]
        rows  = table.search('tr')
        beer_names = rows.map { |r| r.search('td')[0].text }
        breweries  = rows.map { |r| r.search('td')[2].text }
        beers = breweries.zip(beer_names)
        beers[1..-1].map { |ary| ary.join ' ' }
      end

      def url
        URL
      end

      def address
        ADDRESS
      end
    end
  end
end
