class RemoveSyncToGoogleFromWebMenus < ActiveRecord::Migration[5.0]
  def change
    remove_column :web_menus, :sync_to_google
  end
end
