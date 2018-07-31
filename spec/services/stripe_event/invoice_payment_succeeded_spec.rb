require 'spec_helper'

module StripeEvent
  describe InvoicePaymentSucceeded do
    let(:event_data) do
      JSON.parse(
        IO.read(
          Rails.root.join('spec', 'support', 'webhooks', 'invoice.payment_succeeded.json')
        ), symbolize_names: true
      )
    end
    let(:event) { Stripe::Event.construct_from event_data }
    let(:instance) { InvoicePaymentSucceeded.new(event) }

    describe '.handles' do
      it 'handles "invoice.payment_succeeded"' do
        expect(Handler.for('invoice.payment_succeeded')).to eq InvoicePaymentSucceeded
      end
    end

    describe '#invoice' do
      let(:invoice) { instance.invoice }

      it 'returns the Stripe::Invoice object' do
        expect(invoice).to be_a Stripe::Invoice
        expect(invoice.customer).to eq 'cus_DHp2EbahQyQruN'
      end
    end

    describe '#call', :vcr do
      let(:account) { create :account, stripe_id: event.data.object.customer }
      let(:plan) { create :plan }
      let!(:subscription) do
        Subscription.create!({
          account: account,
          plan: plan,
          remote_id: 'sub_DIxKgRIHdUSDSQ',
          payment_method: 'stripe',
          status: :pending_initial_payment
        })
      end

      before do
        Timecop.freeze Date.parse('2018-07-30')
      end

      after do
        Timecop.return
      end

      it 'creates a Payment to represent the Stripe charge' do
        expect {
          instance.call
        }.to change(Payment, :count).by 1
        payment = Payment.last
        expect(payment.account).to eq account
        expect(payment.price_cents).to eq 7900
        expect(payment.status).to eq 'succeeded'
        expect(payment.payment_method).to eq 'stripe'
        expect(payment.response_id).to eq 'ch_1CrFQLFuGCUWqFqF2gvAZ6oC'
        expect(JSON.parse(payment.full_response)['id']).to eq 'ch_1CrFQLFuGCUWqFqF2gvAZ6oC'
      end

      it 'updates the subscription' do
        instance.call
        subscription.reload
        expect(subscription.status).to eq 'active'
        expect(subscription.end_date).to eq Date.parse('2018-08-30')
      end
    end
  end
end
