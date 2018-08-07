class AddQuantityToSubscriptions < ActiveRecord::Migration[5.0]
  def change
    add_column :subscriptions, :quantity, :integer, default: 1
  end
end
