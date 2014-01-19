module Api
  module V1
    class BeersController < ApiController

      def index
        beers = Beer.at_establishment(params[:establishment_id]).names_like params[:beer]
        respond_with beers, root: false
      end
    end
  end
end
