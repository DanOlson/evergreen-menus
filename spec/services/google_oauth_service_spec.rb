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
      expect(String(client.redirect_uri)).to eq 'http://admin.test.evergreenmenus.com/oauth/google/callback'
    end

    it 'has a client_id' do
      expect(client.client_id).to_not be_nil
    end

    it 'has a client_secret' do
      expect(client.client_secret).to_not be_nil
    end
  end

  describe '#exchange' do
    let(:mock_token) do
      {
        access_token: 'asdf',
        refresh_token: 'qwer',
        expires_in: 3600,
        token_type: 'Bearer'
      }
    end
    let(:mock_client) do
      double('MockSignetClient', :code= => nil, fetch_access_token!: mock_token)
    end
    let(:account) { create :account }
    let(:service) { GoogleOauthService.new mock_client }

    it 'exchanges code for tokens' do
      result = service.exchange code: 'foo', account: account
      expect(mock_client).to have_received(:code=).with('foo')
      expect(result).to eq mock_token
    end

    it 'saves the token data to the database' do
      expect {
        service.exchange code: 'foo', account: account
      }.to change(AuthToken, :count).by 1

      token_data = AuthToken.google.for_account(account).first.token_data
      expect(token_data).to eq mock_token.stringify_keys
    end
  end

  describe '#fetch_token' do
    let(:mock_token) do
      {
        access_token: 'asdf',
        refresh_token: 'qwer',
        expires_in: 3600,
        token_type: 'Bearer'
      }
    end
    let(:mock_client) do
      double('MockSignetClient')
    end
    let(:account) { create :account }
    let(:service) { GoogleOauthService.new mock_client }

    context 'when there is no token' do
      it 'returns nil' do
        expect(service.fetch_token(account)).to be_nil
      end
    end

    context 'when the saved token has not yet expired' do
      let(:now) { Time.zone.now }

      before do
        AuthToken.google.for_account(account).create!({
          token_data: mock_token,
          created_at: now,
          updated_at: now
        })
      end

      it 'returns the saved data' do
        token = service.fetch_token account
        expect(token).to eq mock_token
      end
    end

    context 'when the saved token has expired' do
      let(:now) { Time.zone.now - 3601.seconds }
      let(:fresh_token) do
        {
          access_token: 'muchnewerandbetteraccesstoken',
          refresh_token: 'qwer',
          expires_in: 3600,
          token_type: 'Bearer'
        }
      end

      before do
        AuthToken.google.for_account(account).create!({
          token_data: mock_token,
          created_at: now,
          updated_at: now
        })
      end

      it 'fetches a new token, saves it, and returns it' do
        expect(mock_client).to receive(:fetch_access_token!) { fresh_token }

        token = service.fetch_token account
        expect(token).to eq fresh_token

        saved_token = AuthToken.google.for_account(account).first
        expect(saved_token.token_data).to eq fresh_token.stringify_keys
      end
    end
  end

  describe '#revoke' do
    let(:account) { create :account }
    let(:service) { GoogleOauthService.new }

    context 'when there is a token' do
      before do
        AuthToken.google.for_account(account).create!({
          token_data: {
            access_token: 'asdf',
            refresh_token: 'q432423',
            expires_in: 3600,
            token_type: 'Bearer'
          }
        })
      end

      it 'deletes the token' do
        expect {
          service.revoke account
        }.to change(AuthToken, :count).by -1
        expect(AuthToken.google.for_account(account).exists?).to eq false
      end
    end

    context 'when there is no token' do
      it 'deletes no tokens' do
        expect {
          service.revoke account
        }.to_not change AuthToken, :count
      end
    end
  end
end
