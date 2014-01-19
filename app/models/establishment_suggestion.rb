class EstablishmentSuggestion < ActiveRecord::Base
  validates :name, :beer_list_url, presence: true
end
