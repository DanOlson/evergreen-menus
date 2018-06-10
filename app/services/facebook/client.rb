require 'facebook_oauth_service'
require 'net/https'

module Facebook
  class Client
    attr_reader :account, :oauth_service

    FB_BASE_URL = 'https://graph.facebook.com'

    def initialize(account:,
                   oauth_service: default_oauth_service,
                   logger: default_logger)
      @account = account
      @oauth_service = oauth_service
      @logger = logger
    end

    def pages
      @logger.info "Fetching pages from Facebook Graph API for account_id: #{account.id}"
      uri = URI(FB_BASE_URL + '/me/accounts')
      with_access_token do |token|
        Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
          request = Net::HTTP::Get.new(uri)
          request['Authorization'] = "Bearer #{token}"

          response = http.request request
          @logger.info "Received #{response.code} from Facebook Graph API"
          response
        end
      end
    end

    private

    def with_access_token
      yield oauth_service.fetch_token account
    end

    def default_oauth_service
      FacebookOauthService.new
    end

    def default_logger
      Rails.logger
    end
  end
end
