class CreateMenuLists < ActiveRecord::Migration[5.0]
  def change
    create_table :menu_lists do |t|
      t.integer :menu_id, null: false
      t.integer :list_id, null: false
      t.integer :position, null: false
      t.timestamps
    end

    add_foreign_key :menu_lists, :menus
    add_foreign_key :menu_lists, :lists
  end
end
