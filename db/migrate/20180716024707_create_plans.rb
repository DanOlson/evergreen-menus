class CreatePlans < ActiveRecord::Migration[5.0]
  def change
    create_table :plans do |t|
      t.string :remote_id
      t.string :name
      t.monetize :price
      t.integer :interval
      t.integer :interval_count
      t.integer :status
      t.text :description

      t.timestamps
    end
  end
end
