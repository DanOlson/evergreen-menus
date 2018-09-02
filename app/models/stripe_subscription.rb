class StripeSubscription < SimpleDelegator
  class << self
    def create(customer:, plan:, quantity:)
      subscription = StripeClient.create_subscription({
        customer: customer.id,
        plan: plan.remote_id,
        quantity: quantity,
        trial_end: (Time.now + 3.weeks).to_i
      })

      new subscription
    end

    def calculate_end_date(plan:, from_date: Date.current.to_date)
      plan.interval_count.send(plan.interval).from_now from_date
    end
  end

  def cancel
    self.class.new delete
  end
end
