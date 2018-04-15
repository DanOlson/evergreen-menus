require 'google_oauth_service'
require 'net/https'

module GoogleMyBusiness
  class Client
    attr_reader :account, :oauth_service

    GMB_BASE_URL = 'https://mybusiness.googleapis.com'

    def initialize(account:,
                   oauth_service: default_oauth_service,
                   logger: default_logger)
      @account = account
      @oauth_service = oauth_service
      @logger = logger
    end

    def accounts
      issue_get accounts_uri
    end

    def locations(account_id)
      issue_get locations_uri(account_id)
    end

    def location(account_id, location_id)
      issue_get location_uri(account_id, location_id)
    end

    private

    def issue_get(uri)
      with_access_token do |token|
        Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
          request = Net::HTTP::Get.new uri
          request['Authorization'] = "Bearer #{token}"

          @logger.info "Fetching Google My Business accounts for account #{account.name} with id: #{account.id}"
          response = http.request request
          @logger.info "Received #{response.code} from Google My Business API"
          response
        end
      end
    end

    def accounts_uri
      URI(GMB_BASE_URL + '/v4/accounts')
    end

    def locations_uri(account_id)
      URI(GMB_BASE_URL + "/v4/accounts/#{account_id}/locations")
    end

    def location_uri(account_id, location_id)
      URI(GMB_BASE_URL + "/v4/accounts/#{account_id}/locations/#{location_id}")
    end

    def with_access_token
      yield oauth_service.fetch_token account
    end

    def default_oauth_service
      GoogleOauthService.new
    end

    def default_logger
      Rails.logger
    end
  end
end
