class AddFontAndFontSizeToMenu < ActiveRecord::Migration[5.0]
  def change
    add_column :menus, :font, :string
    add_column :menus, :font_size, :integer
  end
end
