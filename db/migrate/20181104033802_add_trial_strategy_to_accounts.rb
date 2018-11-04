class AddTrialStrategyToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :trial_strategy, :integer, default: 0
  end
end
