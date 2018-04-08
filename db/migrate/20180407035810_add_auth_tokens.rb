class AddAuthTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :auth_tokens do |t|
      t.references :account, null: false
      t.string :provider, null: false
      t.json :token_data, null: false
      t.timestamps
    end
  end
end
