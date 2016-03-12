module Api
  module V1
    class ScrapersController < ApiController
      before_action :ensure_authenticated_user

      def index
        respond_with Scraper.all
      end
    end
  end
end
