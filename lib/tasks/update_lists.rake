desc 'scrape the beer lists and update the database'
task update_lists: :environment do |t|
  Scraper.queued_for_update.each do |s|
    Interactions::Scraper.new(s).scrape!
  end
end
