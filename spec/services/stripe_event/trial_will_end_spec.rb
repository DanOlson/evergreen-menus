require 'spec_helper'

module StripeEvent
  describe TrialWillEnd do
    let(:event_data) do
      JSON.parse(
        IO.read(
          Rails.root.join('spec', 'support', 'webhooks', 'customer.subscription.trial_will_end.json')
        ), symbolize_names: true
      )
    end
    let(:event) { Stripe::Event.construct_from event_data }
    let(:instance) { TrialWillEnd.new event }

    describe 'handler registry' do
      it 'handles "customer.subscription.trial_will_end"' do
        expect(Handler.for(event)).to be_a TrialWillEnd
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

        it 'sends an email to the customer' do
          expect {
            instance.call
          }.to change(ActionMailer::Base.deliveries, :count).by 1
          email = ActionMailer::Base.deliveries.last
          expect(email.to).to eq ['donny@lebowski.me']
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
