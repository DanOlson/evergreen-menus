module GoogleMyBusiness
  class Service
    attr_reader :account, :client

    def initialize(account:, client: nil)
      @account = account
      @client = client || default_client
    end

    def accounts
      accounts_response = client.accounts
      accounts = JSON.parse(accounts_response.body)['accounts']
      Array(accounts).map { |a| GoogleMyBusiness::Account.new a }
    end

    def locations
      gmb_acct_id = account.google_my_business_account_id
      raise MissingAccountAssociationException unless gmb_acct_id

      response = client.locations gmb_acct_id.split('/').last
      locations = JSON.parse(response.body)['locations']
      Array(locations).map { |l| GoogleMyBusiness::Location.new l }
    end

    private

    def default_client
      Client.new account: @account
    end
  end
end
