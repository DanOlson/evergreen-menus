class StripeCustomer < SimpleDelegator
  class << self
    def create(**args)
      new StripeClient.create_customer args
    end
  end
end
