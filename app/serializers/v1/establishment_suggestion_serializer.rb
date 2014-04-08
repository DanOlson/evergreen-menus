module V1
  class EstablishmentSuggestionSerializer < AppSerializer
    attributes :id, :name, :beer_list_url, :errors

    def include_errors?
      object.errors.any?
    end
  end
end
