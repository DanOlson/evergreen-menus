class UserInvitationsController < ApplicationController
  load_and_authorize_resource :account

  def new
    @user_invitation = UserInvitationForm.new(account: @account)
  end

  def create
    @user_invitation = build_invitation
    if @user_invitation.valid?
      @user_invitation.invite

      notice = "Invitation sent to #{@user_invitation.email}"
      location = if @user_invitation.invite_another?
        new_account_user_invitation_path @account
      else
        account_users_path @account
      end

      redirect_to location, notice: notice
    else
      render :new
    end
  end

  private

  def build_invitation
    if can? :create, @account.user_invitations.new
      UserInvitationForm.new invitation_params
    end
  end

  def invitation_params
    params.require(:user_invitation).permit(
      :first_name,
      :last_name,
      :email,
      :invite_another
    ).merge(account: @account, inviting_user: current_user)
  end
end
