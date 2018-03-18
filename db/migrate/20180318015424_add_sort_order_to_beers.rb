class AddSortOrderToBeers < ActiveRecord::Migration[5.0]
  def change
    add_column :beers, :sort_order, :integer
  end
end
