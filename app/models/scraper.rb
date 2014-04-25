class Scraper < ActiveRecord::Base
  belongs_to :establishment
  validates :establishment, :scraper_class_name, presence: true
end
