class List < ActiveRecord::Base
  TYPES = [
    TYPE_BEER = 'beer',
    TYPE_WINE = 'wine',
    'spirits',
    'cocktails',
    'appetizers',
    'breakfast',
    'lunch',
    TYPE_DINNER = 'dinner',
    'happy hour',
    'late night',
    'other'
  ]

  class << self
    ###
    # Rails assumes +type+ is for STI. This straightens that out.
    def inheritance_column; end
  end

  belongs_to :establishment
  has_many :beers, -> () { order(:name) }, dependent: :destroy

  validates :name, presence: true
  validates :show_price, :show_description, inclusion: { in: [true, false] }
  validates :type, inclusion: { in: TYPES }

  accepts_nested_attributes_for :beers, allow_destroy: true, reject_if: ->(b) { b[:name].blank? }

  def type
    self[:type] || TYPE_BEER
  end
end
