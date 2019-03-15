class AddNotesToLists < ActiveRecord::Migration[5.2]
  def change
    add_column :lists, :notes, :text
    add_column :web_menu_lists, :show_notes_on_menu, :boolean, default: true, null: false
  end
end
