class OauthFacebookController < ApplicationController
  delegate :account, to: :current_user

  def authorize
    redirect_to service.authorization_uri
  end

  def callback
    if params[:error]
      redirect_to account_path(account), alert: 'Access denied'
    else
      service.exchange code: params[:code], account: account
      redirect_to account_path(account), notice: 'Facebook authorization was successful'
    end
  end

  def revoke
    service.revoke account
    redirect_to account_path(account), notice: 'You have disconnected your account from Facebook'
  end

  private

  def service
    FacebookOauthService.new
  end
end
