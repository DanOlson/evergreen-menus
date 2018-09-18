class JsonLdMenuSerializer
  include Rails.application.routes.url_helpers

  MENU_TYPE = 'Menu'
  MENU_SECTION_TYPE = 'MenuSection'
  MENU_ITEM_TYPE = 'MenuItem'
  OFFER_TYPE = 'Offer'
  USD = 'USD'
  LANG_EN = 'English'
  SCHEMA_DOT_ORG = 'http://schema.org'
  SCHEMA_TIME_FORMAT = 'T%H:%M'
  RESTRICTED_DIETS_BY_LABEL_NAME = {
    'Gluten Free' => 'GlutenFreeDiet',
    'Vegan' => 'VeganDiet',
    'Vegetarian' => 'VegetarianDiet',
    'Dairy Free' => 'LowLactoseDiet'
  }

  def initialize(menu:, url:)
    @menu = menu
    @url = url
  end

  def call
    JSON.generate menu_details
  end

  private

  def menu_details
    {
      '@context': SCHEMA_DOT_ORG,
      '@type': MENU_TYPE,
      url: @url,
      mainEntityOfPage: @url,
      inLanguage: LANG_EN,
      hasMenuSection: render_lists
    }.tap do |hsh|
      hsh.merge!(restricted_availability) if @menu.restricted_availability?
    end
  end

  def render_lists
    @menu.lists.map do |list|
      {
        '@type': MENU_SECTION_TYPE,
        name: list.name,
        hasMenuItem: render_items(list)
      }
    end
  end

  def render_items(list)
    list.beers.map do |item|
      label = Array(item.labels).first
      {
        '@type': MENU_ITEM_TYPE,
        name: item.name,
        description: item.description,
        offers: {
          '@type': OFFER_TYPE,
          price: item.price,
          priceCurrency: USD
        }
      }.tap do |h|
        if item.image.attached?
          h['image'] = rails_representation_url(item.image.variant(resize: '300X300'))
        end
      end.merge restricted_diet_for(label)
    end
  end

  def restricted_diet_for(label)
    label = Label.from(label)
    restricted_diet = RESTRICTED_DIETS_BY_LABEL_NAME.fetch(label.name) do
      return {}
    end
    { suitableForDiet: [SCHEMA_DOT_ORG, restricted_diet].join('/') }
  end

  def restricted_availability
    {
      offers: {
        '@type': OFFER_TYPE,
        availabilityStarts: @menu.availability_start_time.strftime(SCHEMA_TIME_FORMAT),
        availabilityEnds: @menu.availability_end_time.strftime(SCHEMA_TIME_FORMAT)
      }
    }
  end
end
