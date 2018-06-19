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
      issue_get uri
    end

    def page(establishment, **opts)
      @logger.info "Fetching page from Facebook Graph API for establishment_id: #{establishment.id}"
      uri = URI(FB_BASE_URL + '/' + establishment.facebook_page_id)
      if fields = opts[:fields]
        uri.query = "fields=#{fields.join(',')}"
      end
      issue_get uri
    end

    def create_tab(establishment)
      @logger.info "Creating tab for establishment_id: #{establishment.id}"
      uri = URI(FB_BASE_URL + '/' + establishment.facebook_page_id + '/tabs')
      token = oauth_service.fetch_page_token establishment
      Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        @logger.info "Request to Facebook Graph API: #{uri}"
        request = Net::HTTP::Post.new(uri)
        request['Authorization'] = "Bearer #{token}"
        request.set_form_data({
          'app_id' => oauth_service.app_id,
          'custom_name' => 'Menu',
          'tab' => "app_#{oauth_service.app_id}"
        })

        response = http.request request
        @logger.info "Received #{response.code} from Facebook Graph API: #{uri}"
        response
      end
    end

    private

    def with_access_token
      yield oauth_service.fetch_token account
    end

    def issue_get(uri)
      with_access_token do |token|
        Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
          @logger.info "Request to Facebook Graph API: #{uri}"
          request = Net::HTTP::Get.new(uri)
          request['Authorization'] = "Bearer #{token}"

          response = http.request request
          @logger.info "Received #{response.code} from Facebook Graph API: #{uri}"
          response
        end
      end
    end

    def default_oauth_service
      FacebookOauthService.new
    end

    def default_logger
      Rails.logger
    end
  end
end
