module Api
  module V1
    class ScrapersController < ApiController
      before_filter :ensure_authenticated_user

      def index
        respond_with Scraper.all
      end
    end
  end
end
