FactoryGirl.define do
  factory :account do
    name { Faker::Company.name }
    active true

    trait :with_subscription do
      transient do
        quantity 1
      end

      after :create do |acct, evaluator|
        plan = Plan.tier_2 || FactoryGirl.create(:plan, :tier2)
        Subscription.create!({
          account: acct,
          plan: plan,
          quantity: evaluator.quantity,
          status: :active,
          remote_id: 'sub_created_by_factory'
        })
      end
    end
  end
end
