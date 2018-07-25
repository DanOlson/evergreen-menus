require 'spec_helper'

describe StripeClient, :vcr do
  describe '.create_customer' do
    it 'creates a customer with the Stripe API' do
      customer = StripeClient.create_customer({
        email: 'jeff@lebowski.me',
        source: 'tok_1CrGOsFuGCUWqFqFg8KXSmKl'
      })

      expect(customer).to be_a Stripe::Customer
      expect(customer.id).to start_with 'cus_'
      expect(customer.email).to eq 'jeff@lebowski.me'
    end
  end

  describe '.create_subscription' do
    it 'creates a subscription with the Stripe API' do
      subscription = StripeClient.create_subscription({
        customer: 'cus_DHp2EbahQyQruN',
        plan: 'franchisee-development',
        trial_end: 1533608135
      })

      expect(subscription.id).to start_with 'sub_'
      expect(subscription.object).to eq 'subscription'
      expect(subscription.customer).to eq 'cus_DHp2EbahQyQruN'
      expect(subscription.trial_end).to eq 1533608135
      expect(subscription.plan.id).to eq 'franchisee-development'
    end
  end
end
