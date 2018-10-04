FactoryGirl.define do
  factory :user_invitation do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.safe_email }
    account
    association :inviting_user, factory: :user
    role { Role.account_admin }
  end

  factory :signup_invitation do
    account
    email { Faker::Internet.safe_email }
    role { Role.account_admin }
  end
end
