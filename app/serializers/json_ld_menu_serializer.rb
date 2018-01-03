class JsonLdMenuSerializer
  MENU_TYPE = 'Menu'
  MENU_SECTION_TYPE = 'MenuSection'
  MENU_ITEM_TYPE = 'MenuItem'
  MENU_ITEM_OFFER_TYPE = 'Offer'
  USD = 'USD'
  LANG_EN = 'English'
  SCHEMA_DOT_ORG = 'http://schema.org'

  def initialize(menu:, url:)
    @menu = menu
    @url = url
  end

  def call
    JSON.generate({
      '@context': SCHEMA_DOT_ORG,
      '@type': MENU_TYPE,
      url: @url,
      mainEntityOfPage: @url,
      inLanguage: LANG_EN,
      hasMenuSection: render_lists
    })
  end

  private

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
          '@type': MENU_ITEM_OFFER_TYPE,
          price: item.price,
          priceCurrency: USD
        }
      }
    end
  end
end
