class EstablishmentSuggestion < ActiveRecord::Base
  validates :name, :beer_list_url, presence: true

  default_scope { where deleted_at: nil }
end
