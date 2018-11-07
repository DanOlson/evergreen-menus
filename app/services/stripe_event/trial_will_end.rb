module StripeEvent
  class TrialWillEnd < Handler
    handles 'customer.subscription.trial_will_end'

    def call
      if invitation = signup_invitation
        WelcomeMailer.trial_will_end_email(invitation.email).deliver_now
      end
    end

    def customer_id
      customer.customer
    end

    private

    def signup_invitation
      SignupInvitation
        .select(:email)
        .joins(:account)
        .where(accounts: { stripe_id: customer_id })
        .first
    end

    def customer
      event.data.object
    end
  end
end
