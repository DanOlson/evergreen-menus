module StripeEvent
  class InvoicePaymentSucceeded < Handler
    handles 'invoice.payment_succeeded'

    def invoice
      @event.data.object
    end

    def call
      ActiveRecord::Base.transaction do
        subscription.update!({
          status: :active,
          end_date: new_end_date
        })

        Payment.create!({
          account: account,
          price_cents: invoice.amount_paid,
          status: :succeeded,
          payment_method: 'stripe',
          response_id: invoice.charge,
          full_response: charge.to_json
        })
      end
    rescue => e
      @logger.error "Failed to create Payment."
      @logger.error e.message
      @logger.error e.backtrace.join("\n")
    end

    private

    def new_end_date
      plan = invoice.lines.data.first.plan
      StripeSubscription.calculate_end_date plan: plan
    end

    def subscription
      @subscription ||= Subscription.find_by remote_id: invoice.subscription
    end

    def account
      Account.find_by stripe_id: invoice.customer
    end

    def charge
      StripeClient.fetch_charge invoice.charge
    end
  end
end
