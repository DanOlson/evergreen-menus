class CreateListUpdates < ActiveRecord::Migration
  def change
    create_table :list_updates do |t|
      t.references :establishment
      t.string :status, limit: 50, null: false
      t.string :notes
      t.text :raw_data
      t.timestamps
    end
  end
end
