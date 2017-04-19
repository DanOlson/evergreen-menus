class UsersController < ApplicationController
  load_and_authorize_resource :account
  load_and_authorize_resource :user, through: :account

  def index
    @user_invitations = @account.user_invitations
                                .accessible_by(current_ability)
                                .where(accepted: false)
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to account_users_path(@account), notice: "Updated #{@user.first_name} #{@user.last_name}"
    else
      render :edit, alert: @user.errors.full_messages
    end
  end

  private

  def user_params
    params[:user].permit :role_id
  end
end
