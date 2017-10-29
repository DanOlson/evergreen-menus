require Rails.root.join 'db/seeds/role_seeder'

###
# Stub Geocoder requests
load Rails.root.join 'spec/support/geocoder.rb'

FactoryGirl.find_definitions if FactoryGirl.factories.none?
[EstablishmentStaffAssignment, Establishment, UserInvitation, User].each &:destroy_all

RoleSeeder.call

admin = FactoryGirl.create :user, :admin, {
  username: 'admin',
  password: 'password'
}

account = FactoryGirl.create :account
user    = FactoryGirl.create :user, :manager, {
  username: 'manager',
  password: 'password',
  account: account
}

staff   = FactoryGirl.create :user, {
  username: 'staff',
  password: 'password',
  account: account
}

bulldog = Establishment.create!({
  name: 'Bulldog Northeast',
  street_address: '401 E Hennepin Ave',
  city: 'Minneapolis',
  state: 'MN',
  postal_code: '55414',
  account: account,
  url: 'http://thebulldognortheast.com'
})
Scraper.create!({
  establishment: bulldog,
  scraper_class_name: 'BeerList::Establishments::BulldogNortheast'
})

macs = Establishment.create!({
  name: "Macs Industrial",
  street_address: '312 Central Ave SE',
  city: 'Minneapolis',
  state: 'MN',
  postal_code: '55414',
  account: account,
  url: 'http://www.macsindustrial.com/'
})
Scraper.create!({
  establishment: macs,
  scraper_class_name: 'BeerList::Establishments::MacsIndustrial'
})

muddy_waters = Establishment.create!({
  name: 'Muddy Waters',
  street_address: '2933 Lyndale Ave S',
  city: 'Minneapolis',
  state: 'MN',
  postal_code: '55408',
  account: account,
  url: 'http://www.muddywatersmpls.com'
})
Scraper.create!({
  establishment: muddy_waters,
  scraper_class_name: 'BeerList::Establishments::MuddyWaters'
})

groveland    = Establishment.create!({
  name: 'Groveland Tap',
  street_address: '1834 St Clair Ave',
  city: 'St Paul',
  state: 'MN',
  postal_code: '55105',
  account: account,
  url: 'http://www.grovelandtap.com'
})
Scraper.create!({
  establishment: groveland,
  scraper_class_name: 'BeerList::Establishments::GrovelandTap'
})

edina_grill    = Establishment.create!({
  name: 'Edina Grill',
  street_address: '5028 France Ave S',
  city: 'Edina',
  state: 'MN',
  postal_code: '55424',
  account: account,
  url: 'http://www.edinagrill.com/current-tap-list'
})
Scraper.create!({
  establishment: edina_grill,
  scraper_class_name: 'BeerList::Establishments::EdinaGrill'
})

happy_gnome  = Establishment.create!({
  name: 'Happy Gnome',
  street_address: '498 Selby Ave',
  city: 'St Paul',
  state: 'MN',
  postal_code: '55102',
  account: account,
  url: 'http://thehappygnome.com'
})
Scraper.create!({
  establishment: happy_gnome,
  scraper_class_name: 'BeerList::Establishments::HappyGnome'
})

busters    = Establishment.create!({
  name: 'Busters On 28th',
  street_address: '4204 S 28th Ave',
  city: 'Minneapolis',
  state: 'MN',
  postal_code: '55406',
  account: account,
  url: 'http://busterson28th.com/bottles/'
})
Scraper.create!({
  establishment: busters,
  scraper_class_name: 'BeerList::Establishments::BustersOn28th'
})

ginger_hop     = Establishment.create!({
  name: "Ginger Hop",
  street_address: '201 E Hennepin Ave',
  city: ' Minneapolis',
  state: 'MN',
  postal_code: '55414',
  account: account,
  url: 'http://www.gingerhop.com/beer'
})
Scraper.create!({
  establishment: ginger_hop,
  scraper_class_name: 'BeerList::Establishments::GingerHop'
})

beers = [
  "3rd Street Three Way Pale Ale",
  "Affligem Noël",
  "Alaskan Smoked Porter vintage 2002",
  "Alaskan Smoked Porter vintage 2004",
  "Alaskan Smoked Porter vintage 2008",
  "Alaskan Smoked Porter vintage 2010",
  "Angry Orchard Cider",
  "Aspall Cider",
  "Avery Collaboration not Litigation",
  "Avery Samael’s Oak Aged Ale",
  "Avery Samael’s Oak Aged Ale",
  "Bad Weather Windvane Red",
  "Bell’s Oberon",
  "Big Wood Bad Axe Imperial IPA",
  "Blanche de Bruxelles",
  "Blanche de Bruxelles  Brasserie Lefebvre",
  "Boulder Mojo on Nitro",
  "Boulevard Tank 7 Saison",
  "Brew Dog Rip Tide ",
  "Brooklyn Irish Style Stout",
  "Brooklyn Local #1 ",
  "Brooklyn Local #2 ",
  "Brooklyn Pilsner",
  "Burton Bridge Olde Expensive Ale ",
  "Bøgedal Nr. 0156  ",
  "Chapeau Faro De Troch",
  "Chapeau Framboise De Troch",
  "Chapeau Kriek De Troch",
  "Chimay Grande Réserve – Blue ",
  "Chimay Première – Red",
  "Chimay Tripel – White ",
  "Cisco Cider",
  "Clown Shoes Clementine  ",
  "Clown Shoes Porcine Unidragon",
  "Dark Horse Artic Dekoorc Eert",
  "Dark Horse Crooked Tree IPA",
  "Dark Horse Edacsac Dekoorc Eert",
  "Dark Horse FF Dekoorc Eert",
  "Deschutes Black Butte Porter",
  "Deschutes Jubel  Vintage 2010 ",
  "DeuS",
  "Duvel ",
  "Flying Dog In Heat Wheat",
  "Founders All Day IPA",
  "Founders Centennial IPA",
  "Founders Double Trouble",
  "Fraoch 20th Anniversary Ale Heather Ales",
  "Fuller’s Organic Honey Dew",
  "Fulton Rye Saison",
  "Fulton Sweet Child O’ Vine",
  "Furthermore Full Thicket",
  "Goose Island 312",
  "Goose Island Big John",
  "Goose Island Lolita ",
  "Grand Teton Sweetgrass APA",
  "Grand Teton Wake Up Call 2011",
  "Great Lakes Dortmunder Gold",
  "Greens Discovery Amber",
  "Greens Endeavour Dubbel ",
  "Greens Quest Tripel ",
  "Harriet Sol Bock",
  "Harviestoun ‘Ola Dubh’ 18 year",
  "Harviestoun ‘Ola Dubh’ 30 year",
  "Hinterland Pub Draught Nitro",
  "Hitachino Nest Espresso Stout",
  "Hitachino Nest Extra High XH",
  "Indeed Day Tripper Pale Ale",
  "J.W. Lees Harvest Ale ",
  "Jan De Lichte",
  "Kasteel Rouge",
  "Kwak  ",
  "La Trappe",
  "La Trappe",
  "La Trappe Witte",
  "Lagunitas IPA",
  "Lagunitas PILS",
  "Lake Superior Kayak Kölsch",
  "Left Hand Chainsaw 2008 ",
  "Left Hand Milk Stout",
  "Left Hand Oak-Aged Widdershins Vintage 2007 ",
  "Left Hand Smoked Goosinator 2007",
  "Lindemans Framboise",
  "Lindemans Kriek",
  "Lucid Air",
  "Lucid Foto ",
  "McNeill’s Sunshine IPA",
  "Millstream Imperial Wit IPA",
  "Moylan’s Ryan Sullivan Imperial Stout",
  "New Belgium Hoppy Bock",
  "New Belgium Rampant Imperial IPA",
  "New Belgium Shift",
  "New Holland Dragon’s Milk",
  "New Holland Pilgrims Dole  Vintage 2008",
  "OIvalde The Auroch’s Horn",
  "Odell IPA",
  "Ommegang Bier de Mars ",
  "Ommegang Three Philosophers 2010",
  "Ommegang Three Philosophers 2011",
  "Ommegang  Rare Vos ",
  "Orval Ale ",
  "O’Hara’s Irish Dry Stout on Nitro",
  "Paulaner Premium Pils",
  "Rochefort 10",
  "Rochefort 8",
  "Rodenbach",
  "Rogue Brewer’s Ale 2008 ",
  "Rogue Captain Sig’s Northwestern Ale",
  "Rush River The Unforgiven Amber",
  "Samuel Smith’s Oatmeal Stout",
  "Scaldis Noël Brasserie Dubuisson Frères",
  "Scaldis Prestige  Brasserie Dubuisson Frères",
  "Somersby",
  "Southern Tier Cuvée Series “One” ",
  "Spaten Optimator",
  "St. Feuillien Brune",
  "St. Feuillien Cuvée De Noël",
  "Summit Extra Pale Ale",
  "Summit Sága IPA",
  "Surly Bender",
  "Surly Coffee Bender",
  "Surly Furious",
  "Thomas Hardy’s Ale O’Hanlon’s Brewing",
  "Tripel Karmeliet ",
  "Two Brothers Bare Tree Weiss Wine Vintage 2008",
  "Tyranena Rocky’s Revenge",
  "Unibroue La Terrible",
  "Unibroue Quatre Centiéme",
  "Unibroue Seigneubiale",
  "Warsteiner",
  "Westmalle Dubbel",
  "Westmalle Tripel ",
  "Widmer Hopside Down",
  "Widmer Omission Lager",
  "Widmer Omission Pale ",
  "la Goudale  Les Brasseurs de Gayant"
]

Establishment.all.each do |est|
  list = est.lists.create!(name: 'Beers', type: List::TYPE_BEER)
  beers.shuffle.take(16).each do |beer_name|
    list.beers.create!({
      name: beer_name.encode,
      price: (3..9).to_a.shuffle.first.to_s,
      description: "#{Faker::Beer.alcohol} - #{Faker::Beer.style} - #{Faker::Beer.ibu}"
    })
  end
end

[bulldog, macs, muddy_waters, groveland].each do |est|
  staff.establishments << est
end
