class AddDigitalDisplayMenus < ActiveRecord::Migration[5.0]
  def change
    create_table :digital_display_menus do |t|
      t.string :name, null: false
      t.integer :establishment_id, null: false
      t.timestamps
    end

    add_foreign_key :digital_display_menus, :establishments
  end
end
