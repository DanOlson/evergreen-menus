require 'spec_helper'

describe 'Facebook OAuth' do
  let(:account) { create :account }
  let(:user) { create :user, account: account }

  before do
    sign_in user
  end

  describe 'GET to /oauth/facebook/authorize' do
    it 'redirects to the right place' do
      get '/oauth/facebook/authorize'

      expect(response).to have_http_status :redirect
      location = response.headers['Location']
      location_uri = URI(location)
      expect(location).to start_with 'https://www.facebook.com/v3.0/dialog/oauth'
      params = Hash[location_uri.query.split('&').map { |pair| pair.split('=') }]

      expect(params['access_type']).to eq 'offline'
      expect(params['client_id']).to eq '1838673429769675'
      expect(params['redirect_uri']).to eq 'https://admin.test.evergreenmenus.com/oauth/facebook/callback'
      expect(params['response_type']).to eq 'code'
      expect(params['state']).to_not be_nil
      # expect(params['scope']).to eq 'manage_pages'
    end
  end

  describe 'GET to /oauth/facebook/callback when access was denied' do
    it 'redirects to the right place' do
      get '/oauth/facebook/callback?error=access_denied#'

      expect(response).to have_http_status :redirect
      location = response.headers['Location']
      expect(URI(location).path).to eq account_path(user.account)
    end
  end

  describe 'DELETE to /oauth/facebook/revoke' do
    before do
      AuthToken.facebook_user.for_account(account).create!({
        token_data: {
          access_token: 'asdf',
          expires_in: 3600,
          token_type: 'Bearer'
        },
        access_token: 'asdf'
      })
    end

    it 'deletes tokens and redirects back' do
      expect(AuthToken.facebook_user.for_account(account).exists?).to eq true

      delete '/oauth/google/revoke'

      expect(response).to have_http_status :redirect
      expect(response['Location']).to eq account_url(account)
      expect(AuthToken.google.for_account(account).exists?).to eq false
    end
  end
end
