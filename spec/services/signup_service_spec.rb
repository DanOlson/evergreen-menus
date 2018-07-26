require 'spec_helper'

describe SignupService do
  describe '#call', :vcr do
    let(:plan) { create :plan, remote_id: 'one-and-done-development' }

    context 'when all goes well' do
      it 'creates an account' do
        instance = SignupService.new({
          email: 'bob@example.com',
          plan_id: plan.id,
          credit_card_token: 'tok_1CrbLWFuGCUWqFqFr5BHz2Uy'
        })

        expect {
          instance.call
        }.to change(Account, :count).by 1

        account = Account.last
        expect(account.stripe_id).to_not be_nil

        expect(instance).to be_success
      end

      it 'creates a subscription for the account' do
        instance = SignupService.new({
          email: 'bob@example.com',
          plan_id: plan.id,
          credit_card_token: 'tok_1CrbNDFuGCUWqFqF3n6PHxvn'
        })

        expect {
          instance.call
        }.to change(Subscription, :count).by 1

        subscription = Subscription.last
        account = Account.last

        expect(subscription.account).to eq account
        expect(subscription.plan).to eq plan
        expect(subscription.remote_id).to start_with 'sub_'
        expect(subscription.payment_method).to eq 'stripe'
        expect(subscription.status).to eq 'pending_initial_payment'

        expect(instance).to be_success
      end

      it 'creates a signup invitation' do
        instance = SignupService.new({
          email: 'bob@example.com',
          plan_id: plan.id,
          credit_card_token: 'tok_1CryOUFuGCUWqFqFlVJV2ovo'
        })

        expect {
          instance.call
        }.to change(SignupInvitation, :count).by 1

        signup_invitation = instance.signup_invitation
        account = Account.last

        expect(signup_invitation.account).to eq account
        expect(signup_invitation.role).to eq Role.manager
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
          credit_card_token: 'tok_1CrbNDFuGCUWqFqF3n6PHxvn' # duplicate token
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
