class AddUrlToEstablishments < ActiveRecord::Migration[4.2]
  def change
    add_column :establishments, :url, :string
  end
end
