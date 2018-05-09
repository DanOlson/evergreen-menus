class CreateGoogleMenuLists < ActiveRecord::Migration[5.0]
  def change
    create_table :google_menu_lists do |t|
      t.integer :google_menu_id, null: false
      t.integer :list_id, null: false
      t.integer :position, null: false
      t.boolean :show_price_on_menu, default: true, null: false
      t.boolean :show_description_on_menu, default: true, null: false

      t.timestamps
    end
    add_index :google_menu_lists, :google_menu_id
    add_index :google_menu_lists, :list_id
    add_foreign_key :google_menu_lists, :google_menus
    add_foreign_key :google_menu_lists, :lists
  end
end
