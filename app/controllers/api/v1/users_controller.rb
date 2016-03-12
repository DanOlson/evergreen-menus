module Api
  module V1
    class UsersController < ApiController
      before_action :ensure_authenticated_user

      def show
        user = User.find params[:id]
        respond_with user
      end
    end
  end
end
