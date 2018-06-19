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

    describe '#pages', :vcr do
      before do
        expect(mock_facebook_oauth_service)
          .to receive(:fetch_token)
          .with(account) { user_token }
      end

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

    describe '#page', :vcr do
      let(:establishment) do
        build_stubbed :establishment, {
          account: account,
          facebook_page_id: '240936686640816'
        }
      end

      before do
        expect(mock_facebook_oauth_service)
          .to receive(:fetch_token)
          .with(account) { user_token }
      end

      context 'with a valid user token' do
        let(:user_token) { 'mock-user-token' }

        it 'fetches the page from the Facebook Graph API' do
          response = instance.page establishment, fields: ['access_token']
          expect(response.code).to eq '200'
          page = JSON.parse response.body
          expect(page['access_token']).to eq 'mock-page-token'
        end

        it 'allows requesting several fields' do
          response = instance.page establishment, fields: %w(name access_token fan_count)
          expect(response.code).to eq '200'
          page = JSON.parse response.body
          expect(page['access_token']).to eq 'mock-page-token'
          expect(page['name']).to eq 'Farbar Minneapolis'
          expect(page['fan_count']).to eq 0
        end
      end

      context 'with an invalid user token' do
        let(:user_token) { 'some-bad-token' }

        it 'returns Unauthorized' do
          response = instance.page establishment, fields: ['access_token']
          expect(response.code).to eq '401'
        end
      end

      context 'with no user token' do
        let(:user_token) { nil }

        it 'returns BadRequest' do
          response = instance.page establishment, fields: ['access_token']
          expect(response.code).to eq '400'
        end
      end
    end

    describe '#create_tab', :vcr do
      let(:establishment) do
        build_stubbed :establishment, {
          account: account,
          facebook_page_id: '240936686640816'
        }
      end

      before do
        allow(mock_facebook_oauth_service)
          .to receive(:app_id) { 1838673429769675 }
        expect(mock_facebook_oauth_service)
          .to receive(:fetch_page_token)
          .with(establishment) { page_token }
      end

      context 'with a valid page token' do
        let(:page_token) do
          'a-valid-page-token'
        end

        it 'returns a successful response' do
          response = instance.create_tab establishment
          expect(response.code).to eq '201'
        end
      end

      context 'with an invalid page token' do
        let(:page_token) do
          'an-invalid-page-token'
        end

        it 'returns an unauthorized response' do
          response = instance.create_tab establishment
          expect(response.code).to eq '401'
        end
      end
    end
  end
end
