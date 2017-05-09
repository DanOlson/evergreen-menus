class CreateMenus < ActiveRecord::Migration[5.0]
  def change
    create_table :menus do |t|
      t.string :name, null: false
      t.integer :establishment_id, null: false
      t.timestamps
    end

    add_foreign_key :menus, :establishments
  end
end
