class UserRegistrationsController < Devise::RegistrationsController
  before_action :find_account, only: [:edit, :update]
  before_action :configure_permitted_parameters, only: :update
  def new
    invitation = get_invitation
    @user = UserRegistrationForm.from_invitation(invitation)
  end

  def create
    @user = UserRegistrationForm.new user_registration_params
    if @user.valid?
      @user.save
      sign_in @user.model, scope: :user
      redirect_to after_sign_in_path_for(@user.model), notice: "Welcome, #{@user.first_name}!"
    else
      render :new
    end
  end

  private

  def find_account
    @account = current_user.account
  end

  def get_invitation
    GlobalID::Locator.locate_signed(params[:invitation], for: 'registration')
  end

  def user_registration_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :email,
      :username,
      :password,
      :password_confirmation,
      :user_invitation_id
    )
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:email])
  end
end
