FactoryGirl.define do
  factory :menu_item, class: Beer do
    name { Faker::Food.dish }
    price { (3..19).to_a.shuffle.first.to_s }
    description { Faker::Food.description }
    association :list, strategy: :build

    trait :beer do
      name { Faker::Beer.name }
      description { "#{Faker::Beer.alcohol} - #{Faker::Beer.style} - #{Faker::Beer.ibu}" }
    end
  end
end
