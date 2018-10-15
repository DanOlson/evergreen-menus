class PriceOption
  USD = 'USD'
  SERVING = 'Serving'
  attr_accessor :currency, :unit
  attr_reader :price

  class << self
    def from(other)
      return other if other.is_a?(PriceOption)
      new other
    end
  end

  def initialize(price:, currency: USD, unit: SERVING)
    self.price = price
    @currency = currency
    @unit = unit
  end

  def price=(price)
    @price = Float(price)
  end
end
