class List < ActiveRecord::Base
  belongs_to :establishment
  has_many :beers, dependent: :destroy

  # validates :name, :show_price, :show_description, presence: true

  accepts_nested_attributes_for :beers, allow_destroy: true, reject_if: ->(b) { b[:name].blank? }
end
