class AddLabelsToBeers < ActiveRecord::Migration[5.0]
  def change
    add_column :beers, :labels, :string
  end
end
