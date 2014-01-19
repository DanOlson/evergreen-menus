class AddActiveToEstablishments < ActiveRecord::Migration
  def change
    add_column :establishments, :active, :boolean, default: true
  end
end
