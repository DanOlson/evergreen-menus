class CreateGoogleMenus < ActiveRecord::Migration[5.0]
  def change
    create_table :google_menus do |t|
      t.string :name
      t.integer :establishment_id

      t.timestamps
    end

    add_index :google_menus, :establishment_id
    add_foreign_key :google_menus, :establishments
  end
end
