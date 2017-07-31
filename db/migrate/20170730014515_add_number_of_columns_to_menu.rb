class AddNumberOfColumnsToMenu < ActiveRecord::Migration[5.0]
  def change
    add_column :menus, :number_of_columns, :integer, default: 1
  end
end
