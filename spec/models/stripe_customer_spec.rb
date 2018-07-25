require 'spec_helper'

describe StripeCustomer do
  describe '.create', :vcr do
    it 'creates a StripeCustomer' do
      args = {
        email: 'aiden.jones.96@example.com',
        source: 'tok_1CrGZRFuGCUWqFqFSEnvi7uR'
      }
      stripe_customer = StripeCustomer.create args
      expect(stripe_customer).to be_a StripeCustomer
      expect(stripe_customer.email).to eq 'aiden.jones.96@example.com'
      expect(stripe_customer.id).to start_with 'cus_'
    end
  end
end
