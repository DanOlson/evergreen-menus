module V1
  class EstablishmentSerializer < AppSerializer
    attributes :id,
               :name,
               :url,
               :address,
               :active,
               :latitude,
               :longitude,
               :created_at,
               :updated_at

    has_many :beers
    embed :ids, include: true
  end
end
