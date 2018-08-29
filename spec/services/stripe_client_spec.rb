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

  describe '.update_customer' do
    context 'when the customer is found' do
      it 'updates the customer' do
        customer = StripeClient.update_customer 'cus_DHp2EbahQyQruN', {
          source: 'tok_1D3aJbFuGCUWqFqFa3tya62B'
        }

        expect(customer).to_not be_nil
      end
    end

    context 'when the customer is not found' do
      it 'errors' do
        expect {
          StripeClient.update_customer nil, {
            source: 'tok_1D3aJbFuGCUWqFqFa3tya62B'
          }
        }.to raise_error(Stripe::InvalidRequestError)
      end
    end
  end

  describe '.create_subscription' do
    it 'creates a subscription with the Stripe API' do
      subscription = StripeClient.create_subscription({
        customer: 'cus_DHp2EbahQyQruN',
        plan: 't3-development',
        quantity: 4,
        trial_end: 1535422788
      })

      expect(subscription.id).to start_with 'sub_'
      expect(subscription.object).to eq 'subscription'
      expect(subscription.customer).to eq 'cus_DHp2EbahQyQruN'
      expect(subscription.quantity).to eq 4
      expect(subscription.trial_end).to eq 1535422788
      expect(subscription.plan.id).to eq 't3-development'
    end
  end
end
