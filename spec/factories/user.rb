FactoryGirl.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    username { Faker::Internet.user_name }
    email { Faker::Internet.safe_email }
    password 'password'
    account
    role { Role.staff }
  end

  trait :admin do
    role { Role.admin }
  end
end
