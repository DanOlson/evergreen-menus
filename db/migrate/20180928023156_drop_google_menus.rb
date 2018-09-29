class DropGoogleMenus < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key "google_menu_lists", "google_menus"
    remove_foreign_key "google_menu_lists", "lists"
    drop_table :google_menu_lists
    drop_table :google_menus
  end
end
