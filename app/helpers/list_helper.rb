module ListHelper
  BEER_GLASS     = 'fa-beer';
  CUTLERY        = 'fa-utensils';
  COFFEE         = 'fa-coffee';

  ICONS_BY_TYPE = {
    'food'  => CUTLERY,
    'drink' => BEER_GLASS,
    'other' => COFFEE
  }

  MENU_ITEM_LABELS = [
    'Gluten Free',
    'Vegan',
    'Vegetarian',
    'Spicy',
    'Dairy Free',
    'House Special'
  ].map { |name| Label.from(name) }

  def list_type_icon(list)
    icon = ICONS_BY_TYPE.fetch(list.type) { CUTLERY }
    content_tag(:span, nil, {
      class: "fas #{icon} fa-lg float-right",
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

  def menu_item_labels
    MENU_ITEM_LABELS.to_json
  end

  def list_json(list)
    ListSerializer.new(list).call(include_items: true)
  end
end
