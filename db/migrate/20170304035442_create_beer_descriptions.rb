class CreateBeerDescriptions < ActiveRecord::Migration[5.0]
  def change
    create_table :beer_descriptions do |t|
      t.text :description
      t.integer :beer_id, null: false

      t.timestamps
    end

    add_foreign_key :beer_descriptions, :beers
  end
end
