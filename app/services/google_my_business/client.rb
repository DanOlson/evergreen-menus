require 'google_oauth_service'
require 'net/https'

module GoogleMyBusiness
  class Client
    attr_reader :account, :oauth_service

    GMB_BASE_URL = 'https://mybusiness.googleapis.com'

    def initialize(account:, oauth_service: default_oauth_service)
      @account = account
      @oauth_service = oauth_service
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

          http.request request
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
  end
end
