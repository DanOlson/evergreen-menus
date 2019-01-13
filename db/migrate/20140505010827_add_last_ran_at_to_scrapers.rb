class AddLastRanAtToScrapers < ActiveRecord::Migration[4.2]
  def change
    add_column :scrapers, :last_ran_at, :timestamp
  end
end
