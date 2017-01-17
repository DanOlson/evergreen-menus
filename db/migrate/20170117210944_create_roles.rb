class CreateRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :roles do |t|
      t.string :name, null: false
      t.timestamps
    end

    add_column :users, :role_id, :integer
    add_foreign_key :users, :roles
  end
end
