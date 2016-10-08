class AddAccountIdToEstablishments < ActiveRecord::Migration[5.0]
  def change
    add_column :establishments, :account_id, :integer

    add_foreign_key :establishments, :accounts
  end
end
