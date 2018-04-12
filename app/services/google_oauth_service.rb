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
    with_new_token do |token_data|
      AuthToken.google.for_account(account).create!({
        access_token: token_data['access_token'],
        refresh_token: token_data['refresh_token'],
        expires_at: Time.now + token_data['expires_in'].seconds,
        token_data: token_data
      })
    end
  end

  def fetch_token(account)
    auth_token = AuthToken.google.for_account(account).first or return
    if auth_token.expired?
      @client.refresh_token = auth_token.refresh_token
      with_new_token do |token_data|
        auth_token.update!({
          token_data: token_data,
          access_token: token_data['access_token'],
          expires_at: Time.now + token_data['expires_in'].seconds
        })
      end
    else
      auth_token.token_data
    end
  end

  def revoke(account)
    AuthToken.google.for_account(account).delete_all
    nil
  end

  private

  def with_new_token
    token_data = @client.fetch_access_token!
    yield token_data
    token_data
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
