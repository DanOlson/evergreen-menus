class AddUrlToEstablishments < ActiveRecord::Migration
  def change
    add_column :establishments, :url, :string
  end
end
