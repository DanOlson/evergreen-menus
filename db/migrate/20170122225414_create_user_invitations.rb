class CreateUserInvitations < ActiveRecord::Migration[5.0]
  def change
    create_table :user_invitations do |t|
      t.string :first_name, null: false
      t.string :last_name
      t.string :email, null: false

      t.integer :inviting_user_id, null: false, references: :user
      t.integer :account_id, null: false, references: :account
      t.boolean :accepted, default: false

      t.timestamps
    end

    add_foreign_key :user_invitations, :accounts
    add_foreign_key :user_invitations, :users, column: :inviting_user_id
  end
end
