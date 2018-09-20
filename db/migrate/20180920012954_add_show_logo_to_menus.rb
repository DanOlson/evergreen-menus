class AddShowLogoToMenus < ActiveRecord::Migration[5.2]
  def change
    add_column :menus, :show_logo, :boolean, default: false
  end
end
