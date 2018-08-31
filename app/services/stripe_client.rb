class StripeClient
  class << self
    def find_customer(customer_id)
      Stripe::Customer.retrieve customer_id
    end

    def create_customer(**args)
      Stripe::Customer.create args
    end

    def update_customer(customer_id, **args)
      Stripe::Customer.update customer_id, args
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
