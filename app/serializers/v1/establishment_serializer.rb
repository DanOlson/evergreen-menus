module V1
  class EstablishmentSerializer < AppSerializer
    attributes :id, :name, :url, :address
    attribute :coordinates, key: :latLng

    has_many :beers

    def include_beers?
      object.include_beers?
    end

    def coordinates
      [object.latitude, object.longitude]
    end
  end
end
