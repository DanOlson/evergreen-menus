class AddEstablishmentSuggestions < ActiveRecord::Migration
  def change
    create_table :establishment_suggestions do |t|
      t.string :name,          null: false
      t.string :beer_list_url, null: false
    end
  end
end
