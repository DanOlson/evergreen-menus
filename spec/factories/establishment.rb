FactoryGirl.define do
  factory :establishment do
    name { Faker::Company.name }
    url { Faker::Internet.url }

    account

    trait :with_logo do
      after :create do |establishment|
        logo = File.open File.expand_path('../../fixtures/files/the-jesus.png', __FILE__)
        establishment.logo.attach({
          io: logo,
          filename: 'the-jesus.png',
          content_type: 'image/png'
        })
        logo.close
      end
    end
  end
end
