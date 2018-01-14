class AddAvailabilityToMenus < ActiveRecord::Migration[5.0]
  def change
    add_column :menus, :availability_start_time, :time
    add_column :menus, :availability_end_time, :time
  end
end
