FactoryGirl.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    username { Faker::Internet.user_name }
    email { Faker::Internet.safe_email }
    password 'password'
    account { create :account, :with_subscription }
    role { Role.staff }
  end

  trait :super_admin do
    role { Role.super_admin }
    account nil
  end

  trait :account_admin do
    role { Role.account_admin }
  end
end
