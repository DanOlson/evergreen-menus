class StripeCustomer < SimpleDelegator
  InvalidRequestError = Class.new(StandardError)

  class << self
    def find(stripe_id)
      new StripeClient.find_customer stripe_id
    rescue Stripe::InvalidRequestError
    end

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
