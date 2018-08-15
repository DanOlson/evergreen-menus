require 'spec_helper'

module StripeEvent
  describe CustomerCreated do
    let(:event_data) do
      JSON.parse(
        IO.read(
          Rails.root.join('spec', 'support', 'webhooks', 'customer.created.json')
        ), symbolize_names: true
      )
    end
    let(:event) { Stripe::Event.construct_from event_data }
    let(:instance) { CustomerCreated.new event }

    describe 'handler registry' do
      it 'handles "customer.created"' do
        expect(Handler.for(event)).to be_a CustomerCreated
      end
    end

    describe '#call' do
      before do
        ActionMailer::Base.deliveries.clear
      end

      context 'when the email is in the system' do
        before do
          account = create :account, stripe_id: 'cus_00000000000000'
          create :signup_invitation, email: 'donny@lebowski.me', account: account
        end

        it 'sends a welcome email' do
          expect {
            instance.call
          }.to change(ActionMailer::Base.deliveries, :count).by 1
        end
      end

      context 'when the email is not in the system' do
        it 'sends no email' do
          expect {
            instance.call
          }.to_not change(ActionMailer::Base.deliveries, :count)
        end
      end
    end

    describe '#customer_id' do
      it 'pulls the id from the event data' do
        expect(instance.customer_id).to eq 'cus_00000000000000'
      end
    end
  end
end
