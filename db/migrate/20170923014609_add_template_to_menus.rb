class AddTemplateToMenus < ActiveRecord::Migration[5.0]
  def change
    add_column :menus, :template, :string, limit: 60
  end
end
