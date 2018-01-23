class AddAvailabilityToWebMenus < ActiveRecord::Migration[5.0]
  def change
    add_column :web_menus, :availability_start_time, :time
    add_column :web_menus, :availability_end_time, :time
  end
end
