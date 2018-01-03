FactoryGirl.define do
  factory :list do
    name 'New List'
    association :establishment, strategy: :build
    type List::TYPE_DINNER

    trait :beer do
      type List::TYPE_BEER
    end

    trait :with_items do
      transient do
        item_count 8
      end

      after(:create) do |list, evaluator|
        if evaluator.type == List::TYPE_BEER
          create_list(:menu_item, evaluator.item_count, :beer, list: list)
        else
          create_list(:menu_item, evaluator.item_count, list: list)
        end
      end
    end

    trait :wine do
      type List::TYPE_WINE
    end
  end
end
