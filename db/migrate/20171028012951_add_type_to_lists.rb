class AddTypeToLists < ActiveRecord::Migration[5.0]
  def change
    add_column :lists, :type, :string, limit: 40

    add_index :lists, :type
  end
end
