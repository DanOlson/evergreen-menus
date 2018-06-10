require 'spec_helper'

module Facebook
  describe Client do
    let(:instance) do
      Client.new({
        account: account,
        oauth_service: mock_facebook_oauth_service
      })
    end
    let(:account) { build_stubbed :account }
    let(:mock_facebook_oauth_service) { double(FacebookOauthService) }

    before do
      expect(mock_facebook_oauth_service)
        .to receive(:fetch_token).with(account) { user_token }
    end

    describe '#pages', :vcr do
      context 'with a valid user token' do
        let(:user_token) { 'mock-user-access-token' }

        it 'fetches the pages from the Facebook Graph API' do
          response = instance.pages
          expect(response.code).to eq '200'
          parsed_response = JSON.parse response.body
          pages = parsed_response['data']
          expect(pages.size).to eq 1

          page = pages.first
          expect(page['access_token']).to eq 'the-mock-page-access-token'
          expect(page['name']).to eq "Betty's Bakery"
          expect(page['id']).to eq '240936686640816'
        end
      end

      context 'with no valid user token' do
        let(:user_token) { nil }

        it 'returns BadRequest' do
          response = instance.pages
          expect(response.code).to eq '400'
        end
      end
    end
  end
end
