module AddressHelper
  module_function
  def generate_address
    street_address = Faker::Address.street_address
    city           = Faker::Address.city
    state          = Faker::Address.state_abbr
    postal_code    = Faker::Address.zip

    "#{street_address}, #{city}, #{state} #{postal_code}"
  end
end

FactoryGirl.define do
  factory :establishment do
    name { Faker::Company.name }
    address { AddressHelper.generate_address }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    url { Faker::Internet.url }

    account
  end
end
