FactoryGirl.define do
  factory :establishment do
    name { Faker::Company.name }
    url { Faker::Internet.url }

    account
  end
end
