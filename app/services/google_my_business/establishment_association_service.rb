module GoogleMyBusiness
  class EstablishmentAssociationService
    attr_reader :ability, :establishment_id, :location_id

    def initialize(ability:,
                   establishment_id:,
                   location_id:)
      @ability = ability
      @establishment_id = establishment_id
      @location_id = location_id
    end

    def call
      relation = Establishment.accessible_by ability

      prev_est = relation.find_by google_my_business_location_id: location_id
      new_est = relation.find_by id: establishment_id

      prev_est.update(google_my_business_location_id: nil) if prev_est
      if new_est
        new_est.update google_my_business_location_id: location_id
        MenuBootstrapper.call({
          establishment: new_est,
          gmb_location_id: new_est.google_my_business_location_id
        })
      end
    end
  end
end
