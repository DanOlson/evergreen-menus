class AddDeletedAtToEstablishmentSuggestions < ActiveRecord::Migration[4.2]
  def change
    add_column :establishment_suggestions, :created_at, :timestamp
    add_column :establishment_suggestions, :updated_at, :timestamp
    add_column :establishment_suggestions, :deleted_at, :timestamp
  end
end
