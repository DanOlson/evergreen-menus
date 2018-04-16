class AddGoogleMyBusinessLocationIdToEstablishments < ActiveRecord::Migration[5.0]
  def change
    add_column :establishments, :google_my_business_location_id, :string
  end
end
