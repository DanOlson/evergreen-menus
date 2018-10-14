class AddShowDescriptionToMenuLists < ActiveRecord::Migration[5.2]
  def change
    add_column :menu_lists, :show_description_on_menu, :boolean, default: true, null: false
  end
end
