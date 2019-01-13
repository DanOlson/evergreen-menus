class CreateApiKeys < ActiveRecord::Migration[4.2]
  def change
    create_table :api_keys do |t|
      t.references :user, null: false
      t.string :access_token, null: false
      t.datetime :expires_at, null: false
      t.timestamps
    end

    add_index :api_keys, :access_token, unique: true
  end
end
