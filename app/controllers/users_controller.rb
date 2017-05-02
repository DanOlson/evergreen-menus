class UsersController < ApplicationController
  load_and_authorize_resource :account
  load_and_authorize_resource :user, through: :account

  def index
    @user_invitations = @account.user_invitations
                                .accessible_by(current_ability)
                                .where(accepted: false)
  end

  def edit
    @user = @account.users
                    .accessible_by(current_ability)
                    .where(id: params[:id])
                    .includes(:establishments)
                    .first
  end

  def update
    params[:user][:establishment_ids] ||= []
    if @user.update(user_params)
      redirect_to account_users_path(@account), notice: "Updated #{@user.first_name} #{@user.last_name}"
    else
      render :edit, alert: @user.errors.full_messages
    end
  end

  def destroy
    @user.destroy
    redirect_to account_users_path(@account), notice: "#{@user.first_name} #{@user.last_name} has been deleted"
  end

  private

  def user_params
    params[:user].permit(:role_id, { establishment_ids: [] })
  end
end
