module GoogleMyBusiness
  class Location
    attr_reader :name, :location_name

    def initialize(args)
      @name = args['name']
      @location_name = args['locationName']
    end
  end
end
