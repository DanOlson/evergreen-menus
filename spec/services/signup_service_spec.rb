require 'spec_helper'

describe SignupService do
  describe '#call', :vcr do
    let(:plan) { create :plan }

    context 'when all goes well' do
      it 'creates an account' do
        instance = SignupService.new({
          email: 'bob@example.com',
          plan_id: plan.id,
          quantity: 3,
          credit_card_token: 'tok_1CwKz7FuGCUWqFqFgHJwtDsA'
        })

        expect {
          instance.call
        }.to change(Account, :count).by 1

        account = Account.last
        expect(account.stripe_id).to_not be_nil
        expect(account).to be_active

        expect(instance).to be_success
      end

      it 'creates a subscription for the account' do
        instance = SignupService.new({
          email: 'bob@example.com',
          plan_id: plan.id,
          quantity: 3,
          credit_card_token: 'tok_1CwL2LFuGCUWqFqF4gPi3imH'
        })

        expect {
          instance.call
        }.to change(Subscription, :count).by 1

        subscription = Subscription.last
        account = Account.last

        expect(subscription.account).to eq account
        expect(subscription.plan).to eq plan
        expect(subscription.quantity).to eq 3
        expect(subscription.remote_id).to start_with 'sub_'
        expect(subscription.payment_method).to eq 'stripe'
        expect(subscription.status).to eq 'pending_initial_payment'
        expect(subscription.trial_strategy).to eq 'without_credit_card'

        expect(instance).to be_success
      end

      it 'creates a signup invitation' do
        instance = SignupService.new({
          email: 'bob@example.com',
          plan_id: plan.id,
          quantity: 3,
          credit_card_token: 'tok_1CwL0LFuGCUWqFqFndfst3jU'
        })

        expect {
          instance.call
        }.to change(SignupInvitation, :count).by 1

        signup_invitation = instance.signup_invitation
        account = Account.last

        expect(signup_invitation.account).to eq account
        expect(signup_invitation.role).to eq Role.account_admin
        expect(signup_invitation.email).to eq 'bob@example.com'
        expect(signup_invitation.accepted).to eq false
        expect(signup_invitation.accepting_user_id).to be_nil
      end
    end

    context 'when something goes wrong' do
      it 'does not create new records' do
        instance = SignupService.new({
          email: 'bob@example.com',
          plan_id: plan.id,
          quantity: 3,
          credit_card_token: 'tok_1CwL0LFuGCUWqFqFndfst3jU' # duplicate token
        })

        expect {
          instance.call
        }.to_not change(Account, :count)

        expect(instance).to_not be_success

        expect {
          instance.call
        }.to_not change(Subscription, :count)

        expect(instance).to_not be_success

        expect {
          instance.call
        }.to_not change(SignupInvitation, :count)

        expect(instance).to_not be_success
      end
    end
  end
end
