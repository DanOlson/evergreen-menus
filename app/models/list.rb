class List < ActiveRecord::Base
  belongs_to :establishment
  has_many :beers, dependent: :destroy

  validates :name, presence: true
  validates :show_price, :show_description, inclusion: { in: [true, false] }

  accepts_nested_attributes_for :beers, allow_destroy: true, reject_if: ->(b) { b[:name].blank? }

  def as_json(options=nil)
    super(options).merge(beerCount: beers.size)
  end
end
