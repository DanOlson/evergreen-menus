module Api
  module V1
    class ApiController < ActionController::Base
      self.responder = ::V1::ApiResponder

      respond_to :json
    end
  end
end
