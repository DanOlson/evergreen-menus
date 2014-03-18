module Api
  module V1
    class EstablishmentSuggestionsController < ApiController
      def index
        suggestions = EstablishmentSuggestion.all
        respond_with suggestions, root: 'suggestions'
      end

      def create
        suggestion = EstablishmentSuggestion.new suggestion_params
        status = suggestion.save ? :created : :bad_request
        respond_with suggestion, status: status
      end

      private

      def suggestion_params
        params[:establishment_suggestion].permit(:name, :beer_list_url)
      end
    end
  end
end
