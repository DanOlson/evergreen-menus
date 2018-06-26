class CreateOnlineMenus < ActiveRecord::Migration[5.0]
  def change
    create_table :online_menus do |t|
      t.string :name
      t.integer :establishment_id

      t.timestamps
    end

    create_table :online_menu_lists do |t|
      t.integer :online_menu_id, null: false
      t.integer :list_id, null: false
      t.integer :position, null: false
      t.boolean :show_price_on_menu, default: true, null: false
      t.boolean :show_description_on_menu, default: true, null: false

      t.timestamps
    end

    add_index :online_menus, :establishment_id
    add_foreign_key :online_menus, :establishments

    add_index :online_menu_lists, :online_menu_id
    add_index :online_menu_lists, :list_id
    add_foreign_key :online_menu_lists, :online_menus
    add_foreign_key :online_menu_lists, :lists
  end
end
