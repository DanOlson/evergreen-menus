class CreateSignupInvitations < ActiveRecord::Migration[5.0]
  def change
    create_table :signup_invitations do |t|
      t.string :email
      t.references :account, foreign_key: true
      t.boolean :accepted, default: false
      t.integer :accepting_user_id, references: :user
      t.references :role, foreign_key: true

      t.timestamps
    end
  end
end
