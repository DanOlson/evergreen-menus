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

  def exchange(code)
    @client.code = code
    @client.fetch_access_token!
  end

  private

  def default_client
    Signet::OAuth2::Client.new({
        authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
        token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
        client_id: APP_CONFIG.fetch(:google_client_id),
        client_secret: APP_CONFIG.fetch(:google_client_secret),
        scope: 'https://www.googleapis.com/auth/plus.business.manage',
        redirect_uri: oauth_google_callback_url
      })
  end
end
