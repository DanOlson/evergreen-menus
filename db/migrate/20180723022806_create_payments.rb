class CreatePayments < ActiveRecord::Migration[5.0]
  def change
    create_table :payments do |t|
      t.references :account, foreign_key: true
      t.monetize :price
      t.string :reference
      t.integer :status
      t.string :payment_method
      t.string :response_id
      t.json :full_response
      t.timestamps
    end
  end
end
