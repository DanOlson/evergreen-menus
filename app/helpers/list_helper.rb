module ListHelper
  COCKTAIL_GLASS = 'fa-glass';
  WINE_GLASS     = 'icon-glass';
  BEER_GLASS     = 'icon-beer';
  CUTLERY        = 'fa-cutlery';
  MOON           = 'fa-moon-o';
  COFFEE         = 'fa-coffee';

  ICONS_BY_TYPE = {
    'beer'       => BEER_GLASS,
    'wine'       => WINE_GLASS,
    'spirits'    => COCKTAIL_GLASS,
    'cocktails'  => COCKTAIL_GLASS,
    'appetizers' => CUTLERY,
    'breakfast'  => CUTLERY,
    'lunch'      => CUTLERY,
    'dinner'     => CUTLERY,
    'happy-hour' => WINE_GLASS,
    'late-night' => MOON,
    'other'      => COFFEE
  }

  def list_type_icon(list)
    icon = ICONS_BY_TYPE.fetch(list.type) { CUTLERY }
    content_tag(:span, nil, {
      class: "fa #{icon} fa-lg float-right",
      aria: {
        hidden: 'true'
      },
      title: list.type
    })
  end

  def list_type_options_json
    List::TYPES.map do |type|
      {
        name: type.titleize,
        value: type
      }
    end.to_json
  end

  def list_json(list)
    list.as_json.merge(beers: list.beers.as_json).to_json
  end
end