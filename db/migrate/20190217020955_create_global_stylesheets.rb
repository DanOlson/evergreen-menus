class CreateGlobalStylesheets < ActiveRecord::Migration[5.2]
  def change
    create_table :global_stylesheets do |t|
      t.references :establishment
      t.text :css
      t.timestamps
    end
  end
end
