class AddColorAndFontColumnsToDigitalDisplayMenus < ActiveRecord::Migration[5.0]
  def change
    add_column :digital_display_menus, :font, :string, limit: 100
    add_column :digital_display_menus, :background_hex_color, :string, limit: 10
    add_column :digital_display_menus, :text_hex_color, :string, limit: 10
    add_column :digital_display_menus, :list_title_hex_color, :string, limit: 10
    add_column :digital_display_menus, :theme, :string, limit: 40
  end
end
