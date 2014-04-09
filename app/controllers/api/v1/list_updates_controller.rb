module Api
  module V1
    class ListUpdatesController < ApiController
      before_filter :ensure_authenticated_user

      def index
        list_updates = ListUpdate.all
        respond_with list_updates
      end
    end
  end
end
