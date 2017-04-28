class CreateInvitationEstablishmentAssignments < ActiveRecord::Migration[5.0]
  def change
    create_table :invitation_establishment_assignments do |t|
      t.integer :user_invitation_id, null: false
      t.integer :establishment_id, null: false
      t.timestamps
    end

    add_foreign_key :invitation_establishment_assignments, :establishments
    add_foreign_key :invitation_establishment_assignments, :user_invitations
  end
end
