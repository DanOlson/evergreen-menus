class AddShowPriceOnMenuToMenuLists < ActiveRecord::Migration[5.0]
  def change
    add_column :menu_lists, :show_price_on_menu, :boolean, default: true, null: false
  end
end
