module StripeEvent
  class NullHandler < Handler
    def call
      message = %(Received Stripe event "#{@event.type}" with id "#{@event.id}")
      @logger.info message
    end
  end
end
