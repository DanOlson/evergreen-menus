module Api
  module V1
    class SessionsController < ApiController
      def create
        if authenticated_user
          api_key = create_api_key
          respond_with api_key, location: nil, serializer: ::V1::ApiKeySerializer
        else
          render json: {}, status: 401
        end
      end

      private

      ###
      # TODO: Find or create, or implement maximum active tokens
      def create_api_key
        Interactions::ApiKey.create user_id: user.id
      end

      def authenticated_user
        user && user.valid_password?(params[:password])
      end

      def user
        @user ||= User.find_by_username params[:username]
      end
    end
  end
end
