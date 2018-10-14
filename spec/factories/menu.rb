FactoryGirl.define do
  factory :menu do
    name 'Dinner Menu'
    association :establishment, strategy: :build

    trait :with_lists do
      transient do
        list_count 2
      end

      after(:create) do |menu, evaluator|
        list_names = %w(Appetizers Salads Sandwiches Burgers Entrees)

        evaluator.list_count.times do |t|
          list_name = list_names[t]
          list = create :list, :with_items, {
            name: list_name,
            description: "Our #{list_name.downcase} are made fresh daily",
            establishment: menu.establishment
          }
          menu.menu_lists.create({
            position: t,
            show_price_on_menu: true,
            show_description_on_menu: true,
            list: list
          })
        end
      end
    end
  end
end
