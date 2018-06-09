require 'spec_helper'

describe FacebookOauthService do
  describe '#authorization_uri' do
    it 'delegates to the client' do
      client = double('MockSignetClient').as_null_object
      state = Base64.urlsafe_encode64 'establishment-123'
      service = FacebookOauthService.new client
      service.authorization_uri({
        establishment_id: '123'
      })
      expect(client).to have_received(:state=).with state
      expect(client).to have_received :authorization_uri
    end

    it 'uses the correct value' do
      expected = 'https://www.facebook.com/v3.0/dialog/oauth'
      expected_state = Base64.urlsafe_encode64 'establishment-123'
      actual = FacebookOauthService.new.authorization_uri({
        establishment_id: '123'
      })
      expect(actual).to start_with expected
      expect(actual).to include "state=#{expected_state}"
    end
  end

  describe '#client' do
    let(:client) do
      FacebookOauthService.new.client
    end

    it 'has the correct token_credential_uri' do
      expected = 'https://graph.facebook.com/v3.0/oauth/access_token'
      expect(String(client.token_credential_uri)).to eq expected
    end

    xit 'has the correct scope' do
      expected = 'manage_pages'
      expect(client.scope).to eq [expected]
    end

    it 'has the correct redirect_uri' do
      expected = 'https://admin.test.evergreenmenus.com/oauth/facebook/callback'
      expect(String(client.redirect_uri)).to eq expected
    end

    it 'has a client_id' do
      begin
        original = ENV['FACEBOOK_CLIENT_ID']
        ENV['FACEBOOK_CLIENT_ID'] = 'theclientid'
        expect(client.client_id).to eq 'theclientid'
      ensure
        ENV['FACEBOOK_CLIENT_ID'] = original
      end
    end

    it 'has a client_secret' do
      begin
        original = ENV['FACEBOOK_CLIENT_SECRET']
        ENV['FACEBOOK_CLIENT_SECRET'] = 'theclientsecret'
        expect(client.client_secret).to eq 'theclientsecret'
      ensure
        ENV['FACEBOOK_CLIENT_SECRET'] = original
      end
    end
  end

  describe '#exchange' do
    let(:mock_token) do
      {
        'access_token' => 'a-mock-access-token',
        'expires_in' => 3600,
        'token_type' => 'Bearer'
      }
    end
    let(:mock_client) do
      double('MockSignetClient', :code= => nil, fetch_access_token!: mock_token)
    end
    let(:establishment) { create :establishment }
    let(:service) { FacebookOauthService.new mock_client }

    it 'exchanges code for token' do
      result = service.exchange code: 'foo', establishment: establishment
      expect(mock_client).to have_received(:code=).with('foo')
      expect(result).to eq nil
      auth_token = AuthToken.facebook.for_establishment(establishment).first
      expect(auth_token.access_token).to eq 'a-mock-access-token'
      expect(auth_token.expires_at).to be_within(1.minute).of(Time.now + 1.hour)
    end

    it 'saves the token data to the database' do
      expect {
        service.exchange code: 'foo', establishment: establishment
      }.to change(AuthToken, :count).by 1

      auth_token = AuthToken.facebook.for_establishment(establishment).first
      token_data = auth_token.token_data
      expect(token_data).to eq mock_token.stringify_keys
      expect(auth_token.access_token).to eq 'a-mock-access-token'
      expect(auth_token.expires_at).to be_within(1.second).of(Time.now + 1.hour)
    end
  end

  describe '#fetch_token' do
    let(:mock_token) do
      {
        'access_token' => 'a-mock-access-token',
        'expires_in' => 3600,
        'token_type' => 'Bearer'
      }
    end
    let(:mock_client) do
      double('MockSignetClient')
    end
    let(:establishment) { create :establishment }
    let(:service) { FacebookOauthService.new mock_client }

    context 'when there is no token' do
      it 'returns nil' do
        expect(service.fetch_token(establishment)).to be_nil
      end
    end

    context 'when the saved token has not yet expired' do
      let(:now) { Time.zone.now }

      before do
        AuthToken.facebook.for_establishment(establishment).create!({
          token_data: mock_token,
          access_token: 'a-mock-access-token',
          expires_at: now + 3600.seconds,
          created_at: now,
          updated_at: now
        })
      end

      it 'returns the saved data' do
        token = service.fetch_token establishment
        expect(token).to eq 'a-mock-access-token'
      end
    end
  end

  describe '#revoke' do
    let(:establishment) { create :establishment }
    let(:service) { FacebookOauthService.new }

    context 'when there is a token' do
      before do
        AuthToken.facebook.for_establishment(establishment).create!({
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
          service.revoke establishment
        }.to change(AuthToken, :count).by -1
        expect(AuthToken.facebook.for_establishment(establishment).exists?).to eq false
      end
    end

    context 'when there is no token' do
      it 'deletes no tokens' do
        expect {
          service.revoke establishment
        }.to_not change AuthToken, :count
      end
    end
  end
end
