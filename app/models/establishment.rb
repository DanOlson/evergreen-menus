class Establishment < ActiveRecord::Base
  validates :name, :url, presence: true
  validates :google_my_business_location_id, uniqueness: true, allow_nil: true, allow_blank: true
  validates :facebook_page_id, uniqueness: true, allow_nil: true, allow_blank: true
  belongs_to :account
  has_many :invitation_establishment_assignments, dependent: :destroy
  has_many :establishment_staff_assignments, dependent: :destroy
  has_many :staff, through: :establishment_staff_assignments, source: :user
  has_many :lists, dependent: :destroy
  has_many :beer_lists, source: :list, class_name: 'List'
  has_many :beers, through: :beer_lists
  has_many :list_updates
  has_many :menus, dependent: :destroy
  has_many :digital_display_menus, dependent: :destroy
  has_many :web_menus, dependent: :destroy
  has_one :online_menu, dependent: :destroy

  accepts_nested_attributes_for :lists, allow_destroy: true

  class << self
    def active
      where active: true
    end
  end
end
