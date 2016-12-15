class Beer < ActiveRecord::Base
  belongs_to :establishment

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
end
