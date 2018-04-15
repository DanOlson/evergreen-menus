module GoogleMyBusiness
  class Service
    attr_reader :account, :client

    def initialize(account:, client: nil)
      @account = account
      @client = client || default_client
    end

    def accounts
      accounts_response = @client.accounts
      accounts = JSON.parse(accounts_response.body)['accounts']
      Array(accounts).map { |a| GoogleMyBusiness::Account.new a }
    end

    private

    def default_client
      Client.new account: @account
    end
  end
end
