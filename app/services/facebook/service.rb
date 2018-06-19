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

    def page(establishment)
      response = @client.page(establishment, fields: Page.fields)
      if response.code == '200'
        Page.new JSON.parse(response.body)
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
