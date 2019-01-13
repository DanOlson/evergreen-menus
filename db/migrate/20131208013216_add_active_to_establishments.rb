class AddActiveToEstablishments < ActiveRecord::Migration[4.2]
  def change
    add_column :establishments, :active, :boolean, default: true
  end
end
