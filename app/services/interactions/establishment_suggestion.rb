module Interactions
  class EstablishmentSuggestion < BaseInteractor
    attr_reader :suggestion

    def initialize(suggestion)
      @suggestion = suggestion
    end

    def destroy
      suggestion.update_attributes deleted_at: now
    end

    private

    def now
      Time.zone.now
    end
  end
end
