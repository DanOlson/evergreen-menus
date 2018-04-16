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

    describe '#locations' do
      let(:mock_client) { double(Client, locations: locations_response) }
      let(:locations_response) do
        double(Net::HTTPResponse, {
          code: '200',
          body: <<~JSON
            {
              "locations": [
                {
                  "name": "accounts/111337701469104826106/locations/17679890243424107126",
                  "locationName": "Farbar",
                  "priceLists": []
                },
                {
                  "name": "accounts/111337701469104826106/locations/17679890243424107127",
                  "locationName": "Closepub",
                  "priceLists": []
                }
              ]
            }
          JSON
        })
      end

      context 'when the account is not associated to a GMB account' do
        it 'raises an error' do
          expect {
            instance.locations
          }.to raise_error(GoogleMyBusiness::MissingAccountAssociationException)
        end
      end

      context 'when the account is associated to a GMB account' do
        let(:account) { build_stubbed :account, google_my_business_account_id: 'account/12345' }

        it 'calls the client with the numeric portion of the account id' do
          instance.locations
          expect(mock_client).to have_received(:locations).with '12345'
        end

        context 'when the call to GMB API is successful' do
          it 'returns an array of Locations' do
            response = instance.locations
            expect(response.size).to eq 2
            expect(response).to all satisfy { |l| l.is_a? Location }

            loc1, loc2 = response
            expect(loc1.name).to eq 'accounts/111337701469104826106/locations/17679890243424107126'
            expect(loc1.location_name).to eq 'Farbar'

            expect(loc2.name).to eq 'accounts/111337701469104826106/locations/17679890243424107127'
            expect(loc2.location_name).to eq 'Closepub'
          end
        end

        context 'when the call to GMB API fails' do
          let(:locations_response) do
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
            expect(instance.locations).to eq []
          end
        end
      end
    end
  end
end
