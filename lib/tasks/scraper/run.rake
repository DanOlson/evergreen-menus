BeerList.configure do |config|
  config.establishments_dir = Rails.root.join 'lib', 'establishments'
end

namespace :scraper do
  desc 'run the given scraper. i.e. rake scraper:run[BlackBirdMinneapolis]'
  task :run, [:scraper] do |t, args|
    scraper = BeerList::Establishments.const_get args.scraper
    puts scraper.new.list
  end
end
