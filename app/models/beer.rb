class Beer < ActiveRecord::Base
  has_many :beer_establishments
  has_many :establishments, through: :beer_establishments

  class << self
    def at_establishment(establishment_id)
      joins(:establishments).
      where(beer_establishments: { establishment_id: establishment_id })
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
end
