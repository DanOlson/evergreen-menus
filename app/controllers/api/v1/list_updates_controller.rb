module Api
  module V1
    class ListUpdatesController < ApiController
      before_filter :ensure_authenticated_user

      def index
        respond_with find_list_updates
      end

      def show
        list_update = ListUpdate.find params[:id]
        respond_with list_update
      end

      private

      def find_list_updates
        Queries::ListUpdate.with_filters(params).run
      end
    end
  end
end
