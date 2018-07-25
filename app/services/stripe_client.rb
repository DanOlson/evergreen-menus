class StripeClient
  class << self
    def create_customer(**args)
      Stripe::Customer.create args
    end

    def create_subscription(customer:, plan:, trial_end:)
      Stripe::Subscription.create({
        customer: customer,
        items: [{ plan: plan }],
        trial_end: trial_end
      })
    end
  end
end
