class AddSyncToGoogleToWebMenus < ActiveRecord::Migration[5.0]
  def change
    add_column :web_menus, :sync_to_google, :boolean
  end
end
