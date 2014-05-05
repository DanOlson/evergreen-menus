class Establishment < ActiveRecord::Base
  geocoded_by :address
  after_create :geocode
  after_update :geocode, if: ->(est){ est.address_changed? }

  validates :name, :address, presence: true

  has_many :beer_establishments, dependent: :destroy
  has_many :beers, through: :beer_establishments
  has_many :list_updates
  has_one :scraper

  paginates_per 100

  accepts_nested_attributes_for :beers, reject_if: ->(b) { b[:name].blank? }

  class << self
    def active
      where active: true
    end

    def with_beer_named_like(name)
      joins(:beers).where Beer.arel_table[:name].matches("%#{name}%")
    end
  end

  def include_beers!
    @include_beers = true
  end

  def include_beers?
    !!@include_beers
  end
end
