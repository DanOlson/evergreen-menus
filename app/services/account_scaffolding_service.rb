class AccountScaffoldingService
  LISTS = [
    { name: 'Appetizers', type: List::TYPE_FOOD },
    { name: 'Burgers', type: List::TYPE_FOOD },
    { name: 'Entrees', type: List::TYPE_FOOD },
    { name: 'Beer', type: List::TYPE_DRINK },
    { name: 'Wine', type: List::TYPE_DRINK }
  ]

  ITEMS_BY_LIST_NAME = {
    'Appetizers' => [
      {
        name: 'Cheese Curds',
        price_options: PriceOption.new(price: '7.50'),
        description: 'Real Wisconsin cheese, deep fried and served piping hot!'
      },
      {
        name: 'Wings',
        price_options: [
          PriceOption.new(price: '4', unit: 'half'),
          PriceOption.new(price: '8', unit: 'whole'),
        ],
        description: 'Our famous hand-spun chicken wings. Choice of sauce or rub'
      },
      {
        name: 'Edamame',
        price_options: PriceOption.new(price: '7'),
        description: 'Fresh, green soybeans baked beneath a parmesan cheese crust'
      },
    ],
    'Burgers' => [
      {
        name: 'Veggie Burger',
        price_options: PriceOption.new(price: 11),
        description: 'Black bean patty, spicy peppers, spring mix and tangy herb vinaigrette.'
      },
      {
        name: 'Turkey Burger',
        price_options: PriceOption.new(price: 12),
        description: 'Turkey and herb mixed burger topped with provolone, tomato, spring mix and thousand island dressing - served on a toasted ciabatta bun'
      },
      {
        name: 'California Burger',
        price_options: PriceOption.new(price: 12.50),
        description: 'Half pound patty of Black Angus beef served with tomato, lettuce, and mayo'
      }
    ],
    'Entrees' => [
      {
        name: 'Fish Tacos',
        price_options: PriceOption.new(price: 18.95),
        description: 'Panko fried tilapia, coleslaw, cilantro, lime aioli sauce and flour tortillas - served with lime seasoned rice and black beans'
      },
      {
        name: 'Pan-Fried Pork Chop',
        price_options: PriceOption.new(price: 21.95),
        description: 'Thick center cut pork chop - seared with herb seasonings, served with housemade plum sauce, choice of potatoes and asparagus'
      },
      {
        name: 'Jambalaya',
        price_options: PriceOption.new(price: 16.95),
        description: 'Blackened chicken, andouille sausage, tomatoes, onions, bell peppers, spiced broth, rice pilaf'
      }
    ],
    'Beer' => [
      {
        name: 'Sam Adams Boston Lager',
        price_options: PriceOption.new(price: 6),
        description: 'Full-flavored with a balance of malty sweetness contrasted by hop spiciness and a smooth finish.'
      },
      {
        name: 'Budweiser',
        price_options: PriceOption.new(price: 5),
        description: 'American-style pale lager'
      },
      {
        name: "Bells's Two Hearted",
        price_options: PriceOption.new(price: 6.50),
        description: 'American IPA brewed with 100% Centennial hops from the Pacific Northwest.'
      }
    ],
    'Wine' => [
      {
        name: 'Gnarly Head Red Blend',
        price_options: [
          PriceOption.new(price: 7, unit: 'glass'),
          PriceOption.new(price: 31, unit: 'bottle'),
        ]
      },
      {
        name: 'Chateau St. Michelle Cabernet Sauvignon',
        price_options: [
          PriceOption.new(price: 9, unit: 'glass'),
          PriceOption.new(price: 39, unit: 'bottle'),
        ]
      },
      {
        name: 'Ravenswood Zinfandel',
        price_options: [
          PriceOption.new(price: 8, unit: 'glass'),
          PriceOption.new(price: 34, unit: 'bottle'),
        ]
      }
    ]
  }

  class << self
    def call(account)
      new(account).call
    end
  end

  attr_reader :account

  def initialize(account)
    @account = account
  end

  def call
    establishment = create_establishment
    import_result = create_lists establishment
    list_ids = import_result.ids
    create_web_menu establishment: establishment, list_ids: list_ids.take(3)
    create_print_menu establishment: establishment, list_ids: list_ids.take(3)
    create_digital_display_menu establishment: establishment, list_ids: list_ids[3..4]
  end

  private

  def create_establishment
    account.establishments.create!(
      name: "Jo's Pub",
      url: 'jospub.example.com'
    )
  end

  def create_lists(establishment)
    lists = LISTS.map do |list|
      List.new(list.merge({
        establishment: establishment,
        beers: items_for(list[:name]).map.with_index do |item_attrs, index|
          Beer.new item_attrs.merge(position: index)
        end
      }))
    end
    List.import lists, recursive: true
  end

  def items_for(list_name)
    Array(ITEMS_BY_LIST_NAME[list_name])
  end

  def create_web_menu(establishment:, list_ids:)
    web_menu = WebMenu.new({
      name: 'Dinner',
      establishment: establishment,
      web_menu_lists: list_ids.map.with_index do |list_id, index|
        WebMenuList.new({
          list_id: list_id,
          position: index,
          show_price_on_menu: true,
          show_description_on_menu: true
        })
      end
    })
    WebMenu.import [web_menu], recursive: true
  end

  def create_print_menu(establishment:, list_ids:)
    menu = Menu.new({
      name: 'Dinner',
      establishment: establishment,
      menu_lists: list_ids.map.with_index do |list_id, index|
        MenuList.new({
          list_id: list_id,
          position: index,
          show_price_on_menu: true
        })
      end
    })
    Menu.import [menu], recursive: true
  end

  def create_digital_display_menu(establishment:, list_ids:)
    digital_display_menu = DigitalDisplayMenu.new({
      name: 'Drinks',
      establishment: establishment,
      digital_display_menu_lists: list_ids.map.with_index do |list_id, index|
        DigitalDisplayMenuList.new({
          list_id: list_id,
          position: index,
          show_price_on_menu: true
        })
      end
    })
    DigitalDisplayMenu.import [digital_display_menu], recursive: true
  end
end
