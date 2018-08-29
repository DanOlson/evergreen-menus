class StripeCustomer < SimpleDelegator
  InvalidRequestError = Class.new(StandardError)

  class << self
    def create(**args)
      new StripeClient.create_customer args
    end

    def update(customer_id, **args)
      new StripeClient.update_customer customer_id, args
    rescue Stripe::InvalidRequestError
      raise InvalidRequestError
    end
  end
end
