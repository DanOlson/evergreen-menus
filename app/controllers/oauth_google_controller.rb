class OauthGoogleController < ApplicationController
  def authorize
    service = GoogleOauthService.new
    redirect_to service.authorization_uri
  end

  def callback
    service = GoogleOauthService.new
    access_token = service.exchange params[:code]
    render json: access_token
    # store the token and redirect
    # redirect_to after_sign_in_path_for(current_user), notice: 'Successfully linked with Google!'
  end
end
