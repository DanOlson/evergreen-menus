class SandboxSignupsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  before_action :sign_out_all_scopes, if: :user_signed_in?
  before_action :forget_return_to

  def create
    service = SandboxSignupService.new signup_params[:email]
    service.call
    user = service.user
    sign_in user, scope: :user
    redirect_to after_sign_in_path_for(user), notice: 'Welcome to Evergreen Menus!'
  rescue SandboxSignupService::EmailTakenError
    redirect_to 'https://evergreenmenus.com?alert=Email%20has%20already%20been%20taken'
  end

  private

  def forget_return_to
    session.delete :user_return_to
  end

  def signup_params
    params[:signup].permit(:email)
  end
end
