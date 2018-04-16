class AddGoogleMyBusinessAccountIdToAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :google_my_business_account_id, :string
  end
end
