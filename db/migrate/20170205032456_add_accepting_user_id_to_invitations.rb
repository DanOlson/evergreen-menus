class AddAcceptingUserIdToInvitations < ActiveRecord::Migration[5.0]
  def change
    add_column :user_invitations, :accepting_user_id, :integer, references: :user

    add_foreign_key :user_invitations, :users, column: :accepting_user_id
  end
end
