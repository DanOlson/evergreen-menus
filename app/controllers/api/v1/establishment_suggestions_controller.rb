module Api
  module V1
    class EstablishmentSuggestionsController < ApiController
      before_filter :validate_api_key

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
        params[:establishment_suggestion].slice(:name, :beer_list_url)
      end

      def validate_api_key
        render nothing: true, status: :forbidden and return unless valid_api_key?
      end
    end
  end
end
