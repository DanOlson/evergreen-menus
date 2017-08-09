class AddDigitalDisplayMenuLists < ActiveRecord::Migration[5.0]
  def change
    create_table :digital_display_menu_lists do |t|
      t.integer :digital_display_menu_id, null: false
      t.integer :list_id, null: false
      t.integer :position, null: false
      t.boolean :show_price_on_menu, null: false, default: true
      t.timestamps
    end

    add_foreign_key :digital_display_menu_lists, :digital_display_menus
    add_foreign_key :digital_display_menu_lists, :lists
  end
end
