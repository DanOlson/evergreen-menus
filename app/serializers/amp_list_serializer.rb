require 'active_support/number_helper'

class AmpListSerializer
  include ActiveSupport::NumberHelper

  attr_reader :list

  def initialize(list)
    @list = list
  end

  def call
    JSON.generate({
      items: @list.beers.map do |item|
        {
          name: item.name,
          description: item.description,
          price: formatted_price(item.price)
        }
      end
    })
  end

  private

  def formatted_price(price)
    precision = (price % 1).zero? ? 0 : 2
    number_to_currency price, precision: precision, significant: false
  end
end
