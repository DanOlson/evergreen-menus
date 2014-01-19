desc 'scrape the beer lists and update the database'
task update_lists: :environment do |t|
  ListManagement::BeerListUpdater.update_lists!
end
