class CreateBeersEstablishmentsAndBeerEstablishments < ActiveRecord::Migration
  def up
    create_table :beers do |t|
      t.string :name
      t.timestamps
    end

    create_table :establishments do |t|
      t.string :name
      t.string :address
      t.timestamps
    end

    create_table :beer_establishments do |t|
      t.integer :beer_id
      t.integer :establishment_id
    end

    add_index :beer_establishments, [:beer_id, :establishment_id]
    add_index :beers, :name
  end

  def down
    drop_table :beers
    drop_table :establishments
    drop_table :beer_establishments
  end
end
