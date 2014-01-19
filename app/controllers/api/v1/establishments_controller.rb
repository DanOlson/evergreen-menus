module Api
  module V1
    class EstablishmentsController < ApiController

      def show
        establishment = Establishment.active.find params[:id]
        establishment.include_beers!
        respond_with establishment, root: false
      end

      def index
        establishments = if params[:beer]
          Establishment.active.with_beer_named_like params[:beer]
        else
          Establishment.active.order(:name).page params[:page]
        end
        respond_with establishments, root: false
      end

      def create
        return unless valid_api_key?
        create_beers if params[:beer_list]
      end

      private

      def create_beers
        params[:beer_list].each do |beer_list_hash|
          Establishment.update_list! JSON.parse(beer_list_hash).symbolize_keys
        end
      end
    end
  end
end
