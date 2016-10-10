class AddAddressFieldsOnEstablishments < ActiveRecord::Migration[5.0]
  def change
    add_column :establishments, :street_address, :string
    add_column :establishments, :city, :string
    add_column :establishments, :state, :string
    add_column :establishments, :postal_code, :string
  end
end
