class AddRoleIdToUserInvitations < ActiveRecord::Migration[5.0]
  def change
    add_column :user_invitations, :role_id, :integer

    add_foreign_key :user_invitations, :roles
  end
end
