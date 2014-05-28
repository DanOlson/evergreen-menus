module Api
  module V1
    class EstablishmentsController < ApiController
      before_filter :ensure_authenticated_user, only: [:update, :create]

      def show
        establishment = find_establishment
        establishment.include_beers!
        respond_with establishment
      end

      def index
        establishments = if params[:beer]
          Establishment.distinct.active.with_beer_named_like(params[:beer]).includes(:beers)
        else
          Establishment.active.includes(:beers).order(:name).page params[:page]
        end
        respond_with establishments
      end

      def create
        establishment = init_establishment
        establishment.save if establishment.valid?
        respond_with establishment
      end

      def update
        establishment = find_establishment
        establishment.update_attributes establishment_params
        respond_with establishment
      end

      private

      def find_establishment
        Establishment.find params[:id]
      end

      def init_establishment
        Establishment.new establishment_params
      end

      def establishment_params
        params[:establishment].permit(:name, :address, :latitude, :longitude, :url, :active)
      end
    end
  end
end
