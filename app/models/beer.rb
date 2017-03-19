class Beer < ActiveRecord::Base
  belongs_to :establishment
  belongs_to :list

  class << self
    def at_establishment(establishment_id)
      where establishment_id: establishment_id
    end

    def names_like(name)
      select(arel_table[:name]).where arel_table[:name].matches("%#{name}%")
    end
  end

  ###
  # FIXME: Work around this. This is an issue with embedding.
  # Use links hash, maybe?
  def active_model_serializer
    V1::BeerSerializer
  end

  def price
    return unless price_in_cents
    Float(price_in_cents) / 100.00
  end

  def price=(price)
    return if price.empty?
    converted = Float(price) * 100
    self.price_in_cents = Integer(converted)
  end

  def as_json(*)
    {
      id: id,
      name: name,
      created_at: created_at,
      updated_at: updated_at,
      establishment_id: establishment_id,
      price: price,
      description: description
    }
  end
end
