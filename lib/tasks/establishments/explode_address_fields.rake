require 'logger'

class AddressExpander
  class << self
    def call(establishment)
      new(establishment).call
    end
  end

  attr_reader :establishment, :logger

  def initialize(establishment, logger: default_logger)
    @establishment = establishment
    @logger        = logger
  end

  def call
    exploded = address_attributes
    logger.info "Updating #{establishment.name}: exploding address #{establishment.address} to #{exploded}"
    success = establishment.update_attributes exploded
    logger.info "#{establishment.name} update success: #{success}"
  end

  def address_attributes
    if address = establishment.address
      street_address, city, state_and_zip = address.split(',').map &:strip
      {
        street_address: street_address,
        city: city,
        state: state_and_zip.split(' ').first,
        postal_code: state_and_zip.split(' ').last
      }
    else
      {}
    end
  end

  def default_logger
    Logger.new STDOUT
  end
end

namespace :establishments do
  task explode_address_fields: :environment do
    Establishment.all.each do |establishment|
      AddressExpander.call establishment
    end
  end
end
