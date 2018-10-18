class Beer < ActiveRecord::Base
  class LabelsType < ActiveModel::Type::Value
    DELIMITER = ','

    def cast(values)
      return unless values

      if values.is_a?(String)
        # We read it from the DB
        values.split(DELIMITER).map { |l| Label.from l }
      else
        values
      end
    end

    def serialize(values)
      values && values.map(&:name).join(DELIMITER)
    end
  end

  attribute :labels, LabelsType.new

  belongs_to :establishment
  belongs_to :list

  has_one_attached :image

  validates :position, presence: true
  validate :price_option_units_are_unique

  class << self
    def at_establishment(establishment_id)
      where establishment_id: establishment_id
    end

    def names_like(name)
      select(arel_table[:name]).where arel_table[:name].matches("%#{name}%")
    end
  end

  def labels=(labels)
    self[:labels] = labels.map { |l| Label.from l }.reject { |l| l.name.empty? }
  end

  def price
    if price_option = price_options.first
      price_option.price
    else
      return unless price_in_cents
      Float(price_in_cents) / 100.00
    end
  end

  def price=(price)
    return if price.empty?
    converted = Float(price) * 100
    self.price_in_cents = Integer(converted)
  end

  def price_options
    read_attribute(:price_options).map { |o| PriceOption.new o.symbolize_keys }
  end

  def price_options=(options)
    price_options = Array.wrap(options).map { |o| PriceOption.from o }
    price_options = price_options.reject { |o| o.price.nil? }
    write_attribute :price_options, price_options
  end

  def as_json(*)
    super().merge({
      'price' => price,
      'labels' => Array(labels),
      }).tap do |h|
      h["priceOptions"] = h.delete('price_options')
      if image.attached?
        h['imageUrl'] = Rails.application.routes.url_helpers.rails_representation_url(image.variant(resize: '100X100'))
        h['imageFilename'] = image.filename
      end
    end
  end

  private

  def price_option_units_are_unique
    unique_units = price_options.map(&:unit).uniq
    if unique_units.size < price_options.size
      errors.add(:price_options, 'may not have duplicate units')
    end
  end
end
