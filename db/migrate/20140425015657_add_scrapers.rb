class AddScrapers < ActiveRecord::Migration
  def change
    create_table :scrapers do |t|
      t.references :establishment
      t.string :scraper_class_name
      t.time :scheduled_run_time
      t.timestamps
    end
  end
end
