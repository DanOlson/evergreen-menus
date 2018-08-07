FactoryGirl.define do
  factory :plan do
    name 'Specialty'
    status :active
    price_cents 5000
    interval :month
    interval_count 1
    description 'up to six establishments'
    remote_id 'specialty-development'
  end
end
