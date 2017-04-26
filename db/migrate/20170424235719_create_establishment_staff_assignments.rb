class CreateEstablishmentStaffAssignments < ActiveRecord::Migration[5.0]
  def change
    create_table :establishment_staff_assignments do |t|
      t.integer :user_id, null: false
      t.integer :establishment_id, null: false
      t.timestamps
    end

    add_foreign_key :establishment_staff_assignments, :establishments
    add_foreign_key :establishment_staff_assignments, :users
  end
end
