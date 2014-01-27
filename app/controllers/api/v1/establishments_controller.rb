module Api
  module V1
    class EstablishmentsController < ApiController

      def show
        establishment = Establishment.active.find params[:id]
        establishment.include_beers!
        respond_with establishment
      end

      def index
        establishments = if params[:beer]
          Establishment.distinct.active.with_beer_named_like params[:beer]
        else
          Establishment.active.order(:name).page params[:page]
        end
        respond_with establishments
      end
    end
  end
end
