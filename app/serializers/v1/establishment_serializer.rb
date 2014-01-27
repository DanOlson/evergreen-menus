module V1
  class EstablishmentSerializer < AppSerializer
    attributes :id,
               :name,
               :url,
               :address,
               :latitude,
               :longitude

    has_many :beers

    def include_beers?
      object.include_beers?
    end
  end
end
