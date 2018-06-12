class AddFacebookAssociationToEstablishments < ActiveRecord::Migration[5.0]
  def change
    add_column :establishments, :facebook_page_id, :string, limit: 30
  end
end
