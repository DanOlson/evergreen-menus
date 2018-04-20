module GoogleMyBusiness
  class LocationUpdateService
    attr_reader :menu_serializer, :api_client

    def initialize(establishment:,
                   menu_serializer: default_menu_serializer,
                   api_client: nil)
      @establishment = establishment
      @menu_serializer = menu_serializer
      @api_client = api_client || default_client
    end

    def call
      api_client.update_location({
        account_id: account_id,
        location_id: location_id,
        body: request_body
      })
    end

    private

    def request_body
      {
        priceLists: @establishment.web_menus.synced_to_google.map do |menu|
          menu_serializer.call menu
        end
      }
    end

    def account_id
      @establishment.google_my_business_location_id.split('/')[1]
    end

    def location_id
      @establishment.google_my_business_location_id.split('/').last
    end

    def default_client
      GoogleMyBusiness::Client.new account: @establishment.account
    end

    def default_menu_serializer
      GoogleMyBusiness::WebMenuSerializer.new
    end
  end
end
