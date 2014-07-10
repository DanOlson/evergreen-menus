desc 'scrape the beer lists and update the database'
task update_lists: :environment do |t|
  Scraper.queued_for_update.readonly(false).each do |s|
    Interactions::Scraper.new(s).scrape!
  end
end
