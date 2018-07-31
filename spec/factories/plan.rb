FactoryGirl.define do
  factory :plan do
    name 'Restauranteur'
    status :active
    price_cents 7900
    interval :month
    interval_count 1
    description 'up to six establishments'
    remote_id 'restauranteur-development'
  end
end
