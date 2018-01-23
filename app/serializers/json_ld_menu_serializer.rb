class JsonLdMenuSerializer
  MENU_TYPE = 'Menu'
  MENU_SECTION_TYPE = 'MenuSection'
  MENU_ITEM_TYPE = 'MenuItem'
  OFFER_TYPE = 'Offer'
  USD = 'USD'
  LANG_EN = 'English'
  SCHEMA_DOT_ORG = 'http://schema.org'
  SCHEMA_TIME_FORMAT = 'T%H:%M'

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
      {
        '@type': MENU_ITEM_TYPE,
        name: item.name,
        description: item.description,
        offers: {
          '@type': OFFER_TYPE,
          price: item.price,
          priceCurrency: USD
        }
      }
    end
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
