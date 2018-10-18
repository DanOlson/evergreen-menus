class PriceOption
  USD = 'USD'
  SERVING = 'Serving'
  attr_accessor :currency, :unit
  attr_reader :price

  class << self
    def from(other)
      return other if other.is_a?(PriceOption)
      new other.symbolize_keys
    end
  end

  def initialize(price: nil, currency: USD, unit: SERVING)
    self.price = price
    @currency = currency
    self.unit = unit
  end

  def price=(price)
    @price = price.present? ? Float(price) : nil
  end

  def unit=(unit)
    @unit = unit.strip
  end
end
