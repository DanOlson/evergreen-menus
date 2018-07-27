class UserInvitationsController < ApplicationController
  load_and_authorize_resource :account
  load_and_authorize_resource :user_invitation, through: :account, only: [:edit, :update, :destroy]

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
      logger.warn "Invitation is not valid: #{@user.errors.full_messages}"
      render :new
    end
  end

  def edit
  end

  def update
    if @user_invitation.update(invitation_params)
      redirect_to account_users_path(@account), notice: 'Invitation updated'
    else
      render :edit, alert: 'There was a problem updating the invitation'
    end
  end

  def destroy
    @user_invitation.destroy
    redirect_to account_users_path(@account), notice: 'Invitation deleted'
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
      :role_id,
      :invite_another,
      { establishment_ids: [] }
    ).merge(account: @account, inviting_user: current_user)
  end
end
