require 'spec_helper'

describe StripeCustomer do
  describe '.find', :vcr do
    it 'finds the customer by id' do
      stripe_customer = StripeCustomer.find 'cus_DHp2EbahQyQruN'
      expect(stripe_customer).to be_a StripeCustomer
      expect(stripe_customer.id).to eq 'cus_DHp2EbahQyQruN'
      expect(stripe_customer.email).to eq 'liam.robinson.16@example.com'
    end

    context 'when the customer cannot be found' do
      it 'returns nil' do
        expect(StripeCustomer.find('fakecustomer')).to eq nil
      end
    end
  end

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

  describe '.update', :vcr do
    context 'when the customer is found' do
      it 'returns the update customer' do
        customer = StripeCustomer.update 'cus_DHp2EbahQyQruN', {
          source: 'tok_1D3aWaFuGCUWqFqFcW4PeJh4'
        }

        expect(customer).to be_a StripeCustomer
        expect(customer.id).to eq 'cus_DHp2EbahQyQruN'
      end
    end

    context 'when the customer is not found' do
      it 'raises a StripeCustomer::InvalidRequestError error' do
        expect {
          StripeCustomer.update 'asdf', {
            source: 'tok_1D3aWaFuGCUWqFqFcW4PeJh4'
          }
        }.to raise_error(StripeCustomer::InvalidRequestError)
      end
    end

    context 'when the source is bad' do
      it 'raises a StripeCustomer::InvalidRequestError error' do
        expect {
          StripeCustomer.update 'cus_DHp2EbahQyQruN', {
            source: 'tok_qwerty'
          }
        }.to raise_error(StripeCustomer::InvalidRequestError)
      end
    end
  end
end
