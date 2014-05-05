class AddLastRanAtToScrapers < ActiveRecord::Migration
  def change
    add_column :scrapers, :last_ran_at, :timestamp
  end
end
