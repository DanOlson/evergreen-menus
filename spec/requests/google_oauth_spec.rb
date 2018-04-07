require 'spec_helper'

describe 'Google OAuth' do
  let(:account) { create :account }
  let(:user) { create :user, account: account }

  before do
    sign_in user
  end

  describe 'GET to /oauth/google/authorize' do
    it 'redirects to the right place' do
      referer = "http://admin.evergreenmenus.locl.com/accounts/#{account.id}"
      get '/oauth/google/authorize', headers: { 'HTTP_REFERER' => referer }

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
end
