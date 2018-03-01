class Establishment < ActiveRecord::Base
  validates :name, :address, :url, presence: true

  belongs_to :account
  has_many :establishment_staff_assignments
  has_many :staff, through: :establishment_staff_assignments, source: :user
  has_many :lists, dependent: :destroy
  has_many :beer_lists, source: :list, class_name: 'List'
  has_many :beers, through: :beer_lists
  has_many :list_updates
  has_many :menus, dependent: :destroy
  has_many :digital_display_menus, dependent: :destroy
  has_many :web_menus, dependent: :destroy

  paginates_per 100

  accepts_nested_attributes_for :lists, allow_destroy: true

  class << self
    def active
      where active: true
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
