require 'signet/oauth_2/client'

class FacebookOauthService
  include Rails.application.routes.url_helpers

  attr_reader :client

  def initialize(client = default_client)
    @client = client
  end

  def authorization_uri
    @client.state = Base64.urlsafe_encode64 "foobar"
    @client.authorization_uri.to_s
  end

  def exchange(code:, account:)
    @client.code = code
    token_data = @client.fetch_access_token!
    AuthToken.facebook_user.for_account(account).create!({
      access_token: token_data['access_token'],
      expires_at: Time.now + token_data['expires_in'].seconds,
      token_data: token_data
    })
    nil # Avoid exposing the refresh_token
  end

  def fetch_token(account)
    auth_token = AuthToken.facebook_user.for_account(account).first or return
    auth_token.access_token
  end

  def fetch_page_token(establishment)
    auth_token = AuthToken
      .facebook_page
      .for_establishment(establishment)
      .first or return
    auth_token.access_token
  end

  def revoke(account)
    AuthToken.facebook_user.for_account(account).delete_all
    nil
  end

  def app_id
    @client.client_id
  end

  private

  def default_client
    Signet::OAuth2::Client.new({
      authorization_uri: 'https://www.facebook.com/v3.0/dialog/oauth',
      token_credential_uri: 'https://graph.facebook.com/v3.0/oauth/access_token',
      client_id: ENV.fetch('FACEBOOK_CLIENT_ID') { APP_CONFIG[:facebook][:client_id] },
      client_secret: ENV.fetch('FACEBOOK_CLIENT_SECRET') { APP_CONFIG[:facebook][:client_secret] },
      redirect_uri: oauth_facebook_callback_url(protocol: 'https')
    })
  end
end
