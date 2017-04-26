class Establishment < ActiveRecord::Base
  geocoded_by :address
  before_save :geocode, if: ->(e) { e.address_changed? }

  validates :name, :address, :url, presence: true

  belongs_to :account
  has_many :establishment_staff_assignments
  has_many :staff, through: :establishment_staff_assignments, source: :user
  has_many :lists, dependent: :destroy
  has_many :beers, through: :lists
  has_many :list_updates
  has_one :scraper

  paginates_per 100

  accepts_nested_attributes_for :lists, allow_destroy: true

  class << self
    def active
      where active: true
    end

    def with_beer_named_like(name)
      joins(:beers).where Beer.arel_table[:name].matches("%#{name}%")
    end
  end

  def address
    self[:address] || "#{street_address}, #{city}, #{state} #{postal_code}"
  end

  def address_changed?
    street_address_changed? ||
    city_changed? ||
    state_changed? ||
    postal_code_changed?
  end
end
