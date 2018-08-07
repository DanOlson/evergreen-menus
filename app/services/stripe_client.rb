class StripeClient
  class << self
    def create_customer(**args)
      Stripe::Customer.create args
    end

    def create_subscription(customer:, plan:, quantity: 1, trial_end:)
      Stripe::Subscription.create({
        customer: customer,
        items: [{ plan: plan, quantity: quantity }],
        trial_end: trial_end
      })
    end

    def fetch_charge(charge_id)
      Stripe::Charge.retrieve charge_id
    end
  end
end
