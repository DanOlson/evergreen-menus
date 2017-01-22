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
    has_one :scraper
    embed :ids, include: true

    def include_scraper?
      !!current_user
    end
  end
end
