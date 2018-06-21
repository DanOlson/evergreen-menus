require 'spec_helper'

describe 'Google OAuth' do
  let(:account) { create :account }
  let(:user) { create :user, account: account }

  before do
    sign_in user
  end

  describe 'GET to /oauth/google/authorize' do
    it 'redirects to the right place' do
      get '/oauth/google/authorize'

      expect(response).to have_http_status :redirect
      location = response.headers['Location']
      location_uri = URI(location)
      expect(location).to start_with 'https://accounts.google.com/o/oauth2/auth'
      params = Hash[location_uri.query.split('&').map { |pair| pair.split('=') }]

      expect(params['access_type']).to eq 'offline'
      expect(params['client_id']).to eq '30386014028-09m1a47opm3leur3t31d71v3137dgbug.apps.googleusercontent.com'
      expect(params['redirect_uri']).to end_with '/oauth/google/callback'
      expect(params['response_type']).to eq 'code'
      expect(params['scope']).to eq 'https://www.googleapis.com/auth/plus.business.manage'
    end
  end

  describe 'GET to /oauth/google/callback when access was denied' do
    it 'redirects to the right place' do
      get '/oauth/google/callback?error=access_denied#'

      expect(response).to have_http_status :redirect
      location = response.headers['Location']
      expect(URI(location).path).to eq account_path(account)
    end
  end

  describe 'DELETE to /oauth/google/revoke' do
    before do
      AuthToken.google.for_account(account).create!({
        access_token: 'asdf',
        token_data: {
          access_token: 'asdf',
          refresh_token: 'qwer',
          expires_in: 3600,
          token_type: 'Bearer'
        }
      })
    end

    it 'deletes tokens and redirects back' do
      expect(AuthToken.google.for_account(account).exists?).to eq true

      delete '/oauth/google/revoke'

      expect(response).to have_http_status :redirect
      expect(response['Location']).to eq account_url(account)
      expect(AuthToken.google.for_account(account).exists?).to eq false
    end

    context 'when there is a GoogleMenu' do
      let(:establishment) { create :establishment, account: account }
      before do
        create :google_menu, establishment: establishment
      end

      it 'deletes the menu' do
        expect(GoogleMenu.where(establishment: establishment).exists?).to eq true

        delete '/oauth/google/revoke'

        expect(GoogleMenu.where(establishment: establishment).exists?).to eq false
      end
    end
  end
end
