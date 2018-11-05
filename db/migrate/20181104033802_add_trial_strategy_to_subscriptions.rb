class AddTrialStrategyToSubscriptions < ActiveRecord::Migration[5.2]
  def change
    add_column :subscriptions, :trial_strategy, :integer, default: 0
  end
end
