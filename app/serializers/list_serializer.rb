class ListSerializer
  def initialize(list)
    @list = list
  end

  def call
    @list.as_json.merge(beers: @list.beers.as_json).to_json
  end
end
