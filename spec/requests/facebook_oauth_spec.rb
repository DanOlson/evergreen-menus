require 'spec_helper'

describe 'Facebook OAuth' do
  let(:establishment) { create :establishment }
  let(:user) { create :user, account: establishment.account }

  before do
    sign_in user
  end

  describe 'GET to /oauth/facebook/authorize' do
    it 'redirects to the right place' do
      get '/oauth/facebook/authorize?establishment_id=42'

      expect(response).to have_http_status :redirect
      location = response.headers['Location']
      location_uri = URI(location)
      expect(location).to start_with 'https://www.facebook.com/v3.0/dialog/oauth'
      params = Hash[location_uri.query.split('&').map { |pair| pair.split('=') }]

      expect(params['access_type']).to eq 'offline'
      expect(params['client_id']).to eq '1838673429769675'
      expect(params['redirect_uri']).to eq 'https://admin.test.evergreenmenus.com/oauth/facebook/callback'
      expect(params['response_type']).to eq 'code'
      expect(params['state']).to eq 'ZXN0YWJsaXNobWVudC00Mg'
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
end
