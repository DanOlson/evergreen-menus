module StripeEvent
  class CustomerCreated < Handler
    handles 'customer.created'

    def call
      stripe_customer_email = customer.email
      if known_email? stripe_customer_email
        WelcomeMailer.welcome_email(stripe_customer_email).deliver_now
      end
    end

    def customer_id
      customer.id
    end

    private

    def known_email?(email)
      if invitation = signup_invitation
        email == invitation.email
      else
        false
      end
    end

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
