class Establishment < ActiveRecord::Base
  geocoded_by :address
  after_create :geocode
  after_update :geocode, if: ->(est) { est.address_changed? }

  validates :name, :address, :url, presence: true

  belongs_to :account
  has_many :beers, dependent: :destroy
  has_many :list_updates
  has_one :scraper

  paginates_per 100

  accepts_nested_attributes_for :beers, allow_destroy: true, reject_if: ->(b) { b[:name].blank? }

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

  def include_beers!
    @include_beers = true
  end

  def include_beers?
    !!@include_beers
  end
end
