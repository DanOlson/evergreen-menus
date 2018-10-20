namespace :price_options do
  desc "migrate list item price to price_options"
  task migrate_prices: :environment do
    Beer.find_each do |item|
      if item.price_options.empty?
        puts "assigning price_options to item.id=#{item.id}, price=#{item.price}"
        item.price_options = PriceOption.new price: item.price
        item.save
      end
    end
  end
end
