class BeerEstablishment < ActiveRecord::Base
  belongs_to :beer
  belongs_to :establishment
end
