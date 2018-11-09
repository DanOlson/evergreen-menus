module StripeEvent
  class TrialWillEnd < Handler
    handles 'customer.subscription.trial_will_end'

    def call
      if invitation = signup_invitation
        WelcomeMailer.trial_will_end_email(
          recipient: invitation.email,
          trial_end_time: trial_end_time
        ).deliver_now
      end
    end

    def customer_id
      subscription.customer
    end

    def trial_end_time
      Time.at subscription.trial_end
    end

    private

    def signup_invitation
      SignupInvitation
        .select(:email)
        .joins(:account)
        .where(accounts: { stripe_id: customer_id })
        .first
    end

    def subscription
      event.data.object
    end
  end
end
