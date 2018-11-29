class SandboxSignupsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  before_action :sign_out_all_scopes, if: :user_signed_in?
  before_action :forget_return_to
  before_action :check_honeypot

  def create
    service = SandboxSignupService.new signup_params[:email]
    service.call
    user = service.user
    sign_in user, scope: :user
    redirect_to after_sign_in_path_for(user), notice: 'Welcome to Evergreen Menus!'
  rescue => e
    logger.error "Error signing up email #{signup_params[:email]}"
    logger.error e.message
    logger.error e.backtrace.join("\n")
    redirect_to new_user_session_path, alert: "We could not sign up #{signup_params[:email]} at this time"
  end

  private

  def check_honeypot
    if signup_params.key?(:enable)
      head :created and return
    end
  end

  def forget_return_to
    session.delete :user_return_to
  end

  def signup_params
    params[:signup].permit(:email, :enable)
  end
end
