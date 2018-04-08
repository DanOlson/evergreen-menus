class OauthGoogleController < ApplicationController
  delegate :account, to: :current_user

  def authorize
    redirect_to service.authorization_uri
  end

  def callback
    service.exchange code: params[:code], account: account
    redirect_to account_path(account), notice: 'Your account is connected with Google!'
  end

  def revoke
    service.revoke account
    redirect_to account_path(account), notice: 'You have disconnected your account from Google'
  end

  private

  def service
    GoogleOauthService.new
  end
end
