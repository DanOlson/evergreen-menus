require 'signet/oauth_2/client'

class GoogleOauthService
  include Rails.application.routes.url_helpers

  attr_reader :client

  def initialize(client = default_client)
    @client = client
  end

  def authorization_uri
    @client.authorization_uri.to_s
  end

  def exchange(code:, account:)
    @client.code = code
    access_token = @client.fetch_access_token!
    AuthToken.google.for_account(account).create!({
      token_data: access_token
    })
    access_token
  end

  def fetch_token(account)
    auth_token = AuthToken.google.for_account(account).first or return
    if token_expired? auth_token
      access_token = @client.fetch_access_token!
      auth_token.update!(token_data: access_token)
      access_token
    else
      auth_token.token_data.symbolize_keys
    end
  end

  def revoke(account)
    AuthToken.google.for_account(account).delete_all
    nil
  end

  private

  def token_expired?(auth_token)
    valid_until = auth_token.updated_at + auth_token.token_data['expires_in'].seconds
    Time.now > valid_until
  end

  def default_client
    Signet::OAuth2::Client.new({
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      client_id: ENV.fetch('GOOGLE_CLIENT_ID') { APP_CONFIG[:google][:client_id] },
      client_secret: ENV.fetch('GOOGLE_CLIENT_SECRET') { APP_CONFIG[:google][:client_secret] },
      scope: 'https://www.googleapis.com/auth/plus.business.manage',
      redirect_uri: oauth_google_callback_url
    })
  end
end
