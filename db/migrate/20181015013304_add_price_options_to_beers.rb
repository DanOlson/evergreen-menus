class AddPriceOptionsToBeers < ActiveRecord::Migration[5.2]
  def change
    add_column :beers, :price_options, :jsonb, default: []
  end
end
