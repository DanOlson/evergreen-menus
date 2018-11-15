FactoryGirl.define do
  factory :plan do
    name 'The Meal'
    status :active
    price_cents 5000
    interval :month
    interval_count 1
    remote_id 't2-development'

    trait :tier_1 do
      name 'The Snack'
      price_cents 3000
      remote_id Plan::TIER_1_REMOTE_ID
      initialize_with { Plan.find_or_create_by remote_id: Plan::TIER_1_REMOTE_ID}
    end

    trait :tier_2 do
      name 'The Meal'
      price_cents 5000
      remote_id Plan::TIER_2_REMOTE_ID
      initialize_with { Plan.find_or_create_by remote_id: Plan::TIER_2_REMOTE_ID}
    end

    trait :tier_3 do
      name 'The Feast'
      price_cents 7500
      remote_id Plan::TIER_3_REMOTE_ID
      initialize_with { Plan.find_or_create_by remote_id: Plan::TIER_3_REMOTE_ID}
    end
  end
end
