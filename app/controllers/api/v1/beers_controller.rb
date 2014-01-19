module Api
  module V1
    class BeersController < ApplicationController

      def index
        beers = Beer.at_establishment(params[:establishment_id]).names_like params[:beer]
        render json: beers, root: false
      end
    end
  end
end
