class MoveDescriptionToBeers < ActiveRecord::Migration[5.0]
  def change
    remove_foreign_key :beer_descriptions, :beers
    drop_table :beer_descriptions

    add_column :beers, :description, :text
  end
end
