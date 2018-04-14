require 'spec_helper'

module GoogleMyBusiness
  describe Client do
    let(:instance) do
      Client.new({
        account: account,
        oauth_service: mock_google_oauth_service
      })
    end
    let(:account) { build_stubbed :account }
    let(:mock_google_oauth_service) { double(GoogleOauthService) }

    before do
      expect(mock_google_oauth_service)
        .to receive(:fetch_token).with(account) { 'mock-access-token' }
    end

    describe 'accounts', :vcr do
      it 'fetches the available accounts from the GMB API' do
        response = instance.accounts
        expect(response.code).to eq '200'
        parsed_response = JSON.parse response.body
        accounts = parsed_response['accounts']
        expect(accounts.size).to eq 2

        account_1, account_2 = accounts
        expect(account_1['name']).to eq 'accounts/117056520034954462844'
        expect(account_1['accountName']).to eq 'Dan Olson'
        expect(account_1['type']).to eq 'PERSONAL'
        expect(account_1['state']).to eq({ 'status' => 'UNVERIFIED' })

        expect(account_2['name']).to eq 'accounts/111337701469104826106'
        expect(account_2['accountName']).to eq 'Farbar Group'
        expect(account_2['type']).to eq 'LOCATION_GROUP'
        expect(account_2['role']).to eq 'OWNER'
        expect(account_2['permissionLevel']).to eq 'OWNER_LEVEL'
        expect(account_1['state']).to eq({ 'status' => 'UNVERIFIED' })
      end
    end

    describe 'locations', :vcr do
      it "fetches the account's locations" do
        response = instance.locations '111337701469104826106'
        expect(response.code).to eq '200'
        parsed_response = JSON.parse response.body
        locations = parsed_response['locations']
        expect(locations.size).to eq 1

        location = locations.first
        expect(location['name']).to eq 'accounts/111337701469104826106/locations/17679890243424107126'
        expect(location['locationName']).to eq 'Farbar'
        expect(location['priceLists'].size).to eq 1
      end
    end

    describe 'location', :vcr do
      it 'fetches the location by id' do
        response = instance.location '111337701469104826106', '17679890243424107126'
        expect(response.code).to eq '200'
        location = JSON.parse response.body
        expect(location['name']).to eq 'accounts/111337701469104826106/locations/17679890243424107126'
        expect(location['locationName']).to eq 'Farbar'
        expect(location['priceLists'].size).to eq 1
      end
    end
  end
end
