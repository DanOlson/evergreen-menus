class AddFieldsToAuthTokens < ActiveRecord::Migration[5.0]
  def change
    add_column :auth_tokens, :establishment_id, :integer
    add_column :auth_tokens, :access_token, :string
    add_column :auth_tokens, :refresh_token, :string
    add_column :auth_tokens, :expires_at, :timestamp

    add_foreign_key :auth_tokens, :establishments
  end
end
