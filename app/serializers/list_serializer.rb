class ListSerializer
  include Rails.application.routes.url_helpers
  extend Forwardable

  def_delegators :@list, :beers, :persisted?, :establishment

  def initialize(list)
    @list = list
  end

  def call(include_items: false, as_json: false)
    serialized = @list.as_json.tap do |hsh|
      hsh[:beers] = beers.as_json if include_items

      if persisted?
        hsh[:href] = account_establishment_list_path(establishment.account, establishment, @list)
      end

      hsh[:itemCount] = beers.size
    end
    as_json ? serialized : serialized.to_json
  end
end
