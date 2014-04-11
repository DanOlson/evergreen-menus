module Api
  module V1
    class ListUpdatesController < ApiController
      before_filter :ensure_authenticated_user

      def index
        list_updates = ListUpdate.all.includes :establishment
        respond_with list_updates
      end

      def show
        list_update = ListUpdate.find params[:id]
        respond_with list_update
      end
    end
  end
end
