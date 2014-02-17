module V1
  class EstablishmentSerializer < AppSerializer
    attributes :id,
               :name,
               :url,
               :address,
               :latitude,
               :longitude

    has_many :beers
    embed :ids, include: true
  end
end
