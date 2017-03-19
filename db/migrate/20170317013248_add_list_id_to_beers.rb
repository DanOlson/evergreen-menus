class AddListIdToBeers < ActiveRecord::Migration[5.0]
  def change
    add_column :beers, :list_id, :integer

    add_foreign_key :beers, :lists
  end
end
