class CreateSubscriptions < ActiveRecord::Migration[5.0]
  def change
    create_table :subscriptions do |t|
      t.references :account, foreign_key: true
      t.references :plan, foreign_key: true
      t.date :start_date
      t.date :end_date
      t.integer :status
      t.string :payment_method
      t.string :remote_id

      t.timestamps
    end
  end
end
