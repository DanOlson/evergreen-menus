FactoryGirl.define do
  factory :account do
    name { Faker::Company.name }
    active true
  end
end
