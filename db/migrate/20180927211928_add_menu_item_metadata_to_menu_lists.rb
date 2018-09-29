class AddMenuItemMetadataToMenuLists < ActiveRecord::Migration[5.2]
  def change
    add_column :menu_lists, :list_item_metadata, :jsonb, default: {}
    add_column :web_menu_lists, :list_item_metadata, :jsonb, default: {}
    add_column :digital_display_menu_lists, :list_item_metadata, :jsonb, default: {}
    add_column :online_menu_lists, :list_item_metadata, :jsonb, default: {}
  end
end
