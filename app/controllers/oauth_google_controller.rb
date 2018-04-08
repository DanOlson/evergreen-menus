class OauthGoogleController < ApplicationController
  def authorize
    service = GoogleOauthService.new
    redirect_to service.authorization_uri
  end

  def callback
    service = GoogleOauthService.new
    service.exchange code: params[:code], account: current_user.account
    redirect_to after_sign_in_path_for(current_user), notice: 'Successfully linked with Google!'
  end
end
