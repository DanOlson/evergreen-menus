class AddStripeIdToAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :stripe_id, :string
  end
end
