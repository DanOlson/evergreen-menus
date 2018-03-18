FactoryGirl.define do
  factory :digital_display_menu do
    name 'Bar - North Wall'
    association :establishment, strategy: :build
  end
end
