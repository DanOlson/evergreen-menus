class CreateWebMenus < ActiveRecord::Migration[5.0]
  def change
    create_table :web_menus do |t|
      t.string :name, null: false
      t.integer :establishment_id, null: false
      t.timestamps
    end

    create_table :web_menu_lists do |t|
      t.integer :web_menu_id, null: false
      t.integer :list_id, null: false
      t.integer :position, null: false
      t.boolean :show_price_on_menu, null: false, default: true
      t.boolean :show_description_on_menu, null: false, default: true
      t.timestamps
    end

    add_foreign_key :web_menus, :establishments
    add_foreign_key :web_menu_lists, :web_menus
    add_foreign_key :web_menu_lists, :lists
  end
end
