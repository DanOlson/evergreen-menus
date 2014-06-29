desc 'scrape the beer lists and update the database'
task update_lists: :environment do |t|
  sql = "select * from scrapers s join establishments e on s.establishment_id = e.id where e.active"
  Scraper.find_by_sql(sql).each do |s|
    Interactions::Scraper.new(s).scrape!
  end
end
