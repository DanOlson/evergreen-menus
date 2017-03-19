class CreateLists < ActiveRecord::Migration[5.0]
  def change
    create_table :lists do |t|
      t.string :name
      t.integer :establishment_id, null: false
      t.boolean :show_price, null: false, default: true
      t.boolean :show_description, null: false, default: true

      t.timestamps
    end

    add_foreign_key :lists, :establishments
  end
end
