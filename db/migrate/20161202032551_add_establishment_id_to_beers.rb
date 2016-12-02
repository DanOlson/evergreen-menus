class AddEstablishmentIdToBeers < ActiveRecord::Migration[5.0]
  def change
    add_column :beers, :establishment_id, :integer, references: :establishments
  end
end
