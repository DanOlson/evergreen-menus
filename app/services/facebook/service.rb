module Facebook
  class Service
    attr_reader :account, :client

    def initialize(account:, client: nil)
      @account = account
      @client = client || default_client
    end

    def pages
      response = @client.pages
      if response.code == '200'
        page_data = JSON.parse(response.body)['data']
        page_data.map { |p| Page.new p }
      elsif response.code == '401'
        raise UnauthorizedError.for_user account
      else
        raise "Error calling Facebook API: #{response.code} #{response.body}"
      end
    end

    def page_access_token(establishment)
      response = @client.page(establishment, fields: 'access_token')
      if response.code == '200'
        JSON.parse(response.body)['access_token']
      elsif response.code == '401'
        raise UnauthorizedError.for_page establishment
      else
        raise "Error calling Facebook API: #{response.code} #{response.body}"
      end
    end

    def create_tab(establishment)
      response = @client.create_tab establishment
      if message = JSON.parse(response.body).dig('error', 'message')
        raise message
      end
    end

    private

    def default_client
      Client.new(account: @account)
    end
  end
end
