class AddRotateIntervalToDigitalDisplayMenus < ActiveRecord::Migration[5.0]
  def change
    add_column :digital_display_menus, :rotate_interval_milliseconds, :integer
  end
end
