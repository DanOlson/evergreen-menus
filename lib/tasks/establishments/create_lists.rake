namespace :establishments do
  desc "create default lists and assign beers"
  task create_lists: :environment do
    Establishment.all.each do |establishment|
      if establishment.lists.none?
        beers = Beer.where(establishment_id: establishment.id)
        list = establishment.lists.create!({ name: 'Beers' })
        beers.each { |b| list.beers << b }
      end
    end
  end
end
