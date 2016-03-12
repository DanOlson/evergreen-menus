module Api
  module V1
    class ListUpdatesController < ApiController
      before_action :ensure_authenticated_user

      def index
        respond_with find_list_updates
      end

      def show
        list_update = ListUpdate.find params[:id]
        respond_with list_update
      end

      def create
        scraper = Interactions::Scraper.new find_scraper
        scraper.scrape! force: true
        respond_with scraper.list_update
      end

      private

      def find_scraper
        Scraper.find_by establishment_id: params[:list_update][:establishment_id]
      end

      def find_list_updates
        Queries::ListUpdate.with_filters(params).run
      end
    end
  end
end
