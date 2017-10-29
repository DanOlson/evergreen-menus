module ListHelper
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
