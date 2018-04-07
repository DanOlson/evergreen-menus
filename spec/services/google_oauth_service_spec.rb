require 'spec_helper'

describe GoogleOauthService do
  describe '#authorization_uri' do
    it 'delegates to the client' do
      client = double('MockSignetClient', authorization_uri: nil)
      service = GoogleOauthService.new client
      service.authorization_uri
      expect(client).to have_received :authorization_uri
    end

    it 'uses the correct value' do
      expected = 'https://accounts.google.com/o/oauth2/auth'
      actual = GoogleOauthService.new.authorization_uri
      expect(actual).to start_with expected
    end
  end

  describe '#client' do
    let(:client) do
      GoogleOauthService.new.client
    end

    it 'has the correct token_credential_uri' do
      expected = 'https://accounts.google.com/o/oauth2/token'
      expect(String(client.token_credential_uri)).to eq expected
    end

    it 'has the correct scope' do
      expected = 'https://www.googleapis.com/auth/plus.business.manage'
      expect(client.scope).to eq [expected]
    end

    it 'has the correct redirect_uri' do
      expect(String(client.redirect_uri)).to eq 'http://admin.evergreenmenus.locl/oauth/google/callback'
    end

    it 'has a client_id' do
      expect(client.client_id).to_not be_nil
    end

    it 'has a client_secret' do
      expect(client.client_secret).to_not be_nil
    end
  end

  describe '#exchange' do
    it 'exchanges code for tokens' do
      mock_token = { access_token: 'asdf', refresh_token: 'qwer' }
      client = double('MockSignetClient', :code= => nil, fetch_access_token!: mock_token)
      service = GoogleOauthService.new client
      result = service.exchange('foo')
      expect(client).to have_received(:code=).with('foo')
      expect(result).to eq mock_token
    end
  end
end
