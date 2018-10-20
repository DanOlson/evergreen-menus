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
  validate :items_have_unique_price_option_units

  accepts_nested_attributes_for :beers, allow_destroy: true, reject_if: ->(b) { b[:name].blank? }

  def type
    self[:type] || TYPE_FOOD
  end

  private

  ###
  # With config.active_record.index_nested_attribute_errors = true
  # we cannot control via i18n the messaging of errors on our nested
  # beer instances. This is a bit of a hack to consolidate issues with
  # duplicate price_option units to a single message on the List instance
  def items_have_unique_price_option_units
    price_option_faults = errors.keys.select { |a| a.to_s =~ /beers\[\d+\]\.price_options/ }
    price_option_faults.each { |f| errors.delete f }
    if price_option_faults.any?
      errors.add :base, 'Item price options may not have duplicate units'
    end
  end
end
