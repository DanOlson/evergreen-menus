module Api
  module V1
    class ApiController < ActionController::Base
      self.responder = ::V1::ApiResponder

      respond_to :json

      protected

      def ensure_authenticated_user
        head :unauthorized unless current_user
      end

      def current_user
        User.joins(:api_keys)
            .where(api_keys: { access_token: token })
            .merge(ApiKey.active)
            .first
      end

      def token
        bearer = request.headers['HTTP_AUTHORIZATION']
        bearer ||= request.headers["rack.session"].try(:[], 'Authorization')
        bearer and bearer.split.last
      end
    end
  end
end
