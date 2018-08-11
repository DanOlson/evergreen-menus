FactoryGirl.define do
  factory :plan do
    name 'The Meal'
    status :active
    price_cents 5000
    interval :month
    interval_count 1
    remote_id 't2-development'

    trait :tier1 do
      name 'The Snack'
      price_cents 3000
      remote_id 't1-development'
    end

    trait :tier2 do
      name 'The Meal'
      price_cents 5000
      remote_id 't2-development'
    end

    trait :tier3 do
      name 'The Feast'
      price_cents 7500
      remote_id 't3-development'
    end
  end
end
