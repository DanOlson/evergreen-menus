class AddPriceToBeers < ActiveRecord::Migration[5.0]
  def change
    add_column :beers, :price_in_cents, :integer
  end
end
