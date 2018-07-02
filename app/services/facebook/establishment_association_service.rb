module Facebook
  class EstablishmentAssociationService
    attr_reader :ability, :facebook_page_id, :establishment_id

    def initialize(ability:,
                   facebook_page_id:,
                   establishment_id:)
      @ability = ability
      @facebook_page_id = facebook_page_id
      @establishment_id = establishment_id
    end

    def call
      relation = Establishment.accessible_by ability

      prev_est = relation.find_by facebook_page_id: facebook_page_id
      new_est = relation.find_by id: establishment_id

      existing_page_token = find_page_token prev_est

      Establishment.transaction do
        prev_est.update(facebook_page_id: nil) if prev_est
        new_est.update(facebook_page_id: facebook_page_id) if new_est
        existing_page_token.update(establishment_id: new_est.id) if new_est && existing_page_token
        existing_page_token.destroy if !new_est && existing_page_token
      end
    end

    private

    def find_page_token(establishment)
      return unless establishment
      AuthToken
        .facebook_page
        .for_establishment(establishment)
        .first
    end
  end
end
