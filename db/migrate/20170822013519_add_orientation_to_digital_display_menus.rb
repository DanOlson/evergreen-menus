class AddOrientationToDigitalDisplayMenus < ActiveRecord::Migration[5.0]
  def change
    add_column :digital_display_menus, :horizontal_orientation, :boolean, null: false, default: true
  end
end
