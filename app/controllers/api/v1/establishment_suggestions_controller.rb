module Api
  module V1
    class EstablishmentSuggestionsController < ApiController
      before_filter :ensure_authenticated_user, only: [:index, :destroy]

      ###
      # TODO: Paginate
      def index
        suggestions = EstablishmentSuggestion.all
        respond_with suggestions, root: 'establishment_suggestions'
      end

      def create
        suggestion = EstablishmentSuggestion.new suggestion_params
        status = suggestion.save ? :created : :bad_request
        respond_with suggestion, status: status
      end

      def destroy
        suggestion = find_suggestion
        interactor = init_interactor suggestion
        interactor.destroy
        respond_with suggestion
      end

      private

      def init_interactor(suggestion)
        Interactions::EstablishmentSuggestion.new suggestion
      end

      def find_suggestion
        EstablishmentSuggestion.find params[:id]
      end

      def suggestion_params
        params[:establishment_suggestion].permit(:name, :beer_list_url)
      end
    end
  end
end
