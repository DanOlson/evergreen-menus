class List < ActiveRecord::Base
  TYPES = [
    TYPE_FOOD  = 'food',
    TYPE_DRINK = 'drink',
    TYPE_OTHER = 'other'
  ]

  class << self
    ###
    # Rails assumes +type+ is for STI. This straightens that out.
    def inheritance_column; end
  end

  belongs_to :establishment
  has_many :beers, -> () { order(:position) }, dependent: :destroy
  has_many :menu_lists, dependent: :destroy
  has_many :digital_display_menu_lists, dependent: :destroy
  has_many :web_menu_lists, dependent: :destroy
  has_many :online_menu_lists, dependent: :destroy

  validates :name, presence: true
  validates :show_price, :show_description, inclusion: { in: [true, false] }
  validates :type, inclusion: { in: TYPES }

  accepts_nested_attributes_for :beers, allow_destroy: true, reject_if: ->(b) { b[:name].blank? }

  def type
    self[:type] || TYPE_FOOD
  end
end
