require 'spec_helper'

module GoogleMyBusiness
  describe Service do
    let(:instance) do
      Service.new(account: account, client: mock_client)
    end
    let(:mock_client) { double(Client) }
    let(:account) { build_stubbed :account }

    describe 'the default client' do
      it 'instantiates a client with the given account' do
        service = Service.new account: account
        expect(service.client.account).to eq account
      end
    end

    describe '#accounts' do
      let(:mock_client) { double(Client, accounts: mock_accounts_response) }

      context 'when the client request is successful' do
        let(:mock_accounts_response) do
          double(Net::HTTPResponse, {
            code: '200',
            body: <<~JSON
            {
              "accounts": [
                {
                  "name": "accounts/117056520034954462844",
                  "accountName": "Dan Olson",
                  "type": "PERSONAL",
                  "state": {
                    "status": "UNVERIFIED"
                  }
                },
                {
                  "name": "accounts/111337701469104826106",
                  "accountName": "Farbar Group",
                  "type": "LOCATION_GROUP",
                  "role": "OWNER",
                  "state": {
                    "status": "UNVERIFIED"
                  },
                  "permissionLevel": "OWNER_LEVEL"
                }
              ]
            }
            JSON
          })
        end

        it 'uses the client to get available accounts' do
          accounts = instance.accounts

          expect(accounts.size).to eq 2
          expect(accounts).to all satisfy { |a| a.is_a? Account }

          farbar = accounts[1]
          expect(farbar.name).to eq 'accounts/111337701469104826106'
          expect(farbar.account_name).to eq 'Farbar Group'
          expect(farbar.type).to eq 'LOCATION_GROUP'
          expect(farbar.role).to eq 'OWNER'
          expect(farbar.state).to eq({ 'status' => 'UNVERIFIED' })
          expect(farbar.permission_level).to eq 'OWNER_LEVEL'
        end
      end

      context 'when the client request is unauthorized' do
        let(:mock_accounts_response) do
          double(Net::HTTPResponse, {
            code: '401',
            body: <<~JSON
              {
                "error": {
                  "code": 401,
                  "message": "Request had invalid authentication credentials.",
                  "status": "UNAUTHENTICATED"
                }
              }
            JSON
          })
        end

        it 'returns an empty array' do
          expect(instance.accounts).to eq []
        end
      end
    end
  end
end
