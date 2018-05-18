module GoogleMyBusiness
  class Location
    attr_reader :name, :location_name, :price_list

    def initialize(args)
      @name = args['name']
      @location_name = args['locationName']
      @price_list = PriceList.new Array(args['priceLists']).first
    end
  end
end
