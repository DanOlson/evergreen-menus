class UsersController < ApplicationController
  load_and_authorize_resource :account
  load_and_authorize_resource :user, through: :account

  def index
    @user_invitations = @account.user_invitations
                                .accessible_by(current_ability)
                                .where(accepted: false)
  end
end
