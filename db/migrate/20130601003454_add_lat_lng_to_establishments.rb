class AddLatLngToEstablishments < ActiveRecord::Migration
  def change
    add_column :establishments, :latitude,  :decimal, { precision: 9, scale: 6 }
    add_column :establishments, :longitude, :decimal, { precision: 9, scale: 6 }
  end
end
