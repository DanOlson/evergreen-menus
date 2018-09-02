require 'spec_helper'

describe AccountCancellationService do
  describe '.call' do
    let(:instance) { instance_double AccountCancellationService, call: nil }

    it 'delegates to an instance' do
      opts = { ability: double, account_id: 1 }
      expect(AccountCancellationService).to receive(:new).with(opts) { instance }
      AccountCancellationService.call opts

      expect(instance).to have_received :call
    end
  end

  describe '#call' do
    let(:account) { create :account, stripe_id: 'cus_123' }
    let(:ability) { double Ability, can?: allowed }
    let(:instance) do
      AccountCancellationService.new({
        ability: ability,
        account_id: account.id
      })
    end

    before do
      expect(ability).to receive(:can?).with(:cancel, account)
    end

    context 'when the given ability is not allowed' do
      let(:allowed) { false }

      it 'does not deactivate the account' do
        instance.call
        account.reload
        expect(account).to be_active
      end
    end

    context 'when the given ability is allowed' do
      let(:allowed) { true }
      let(:stripe_customer) { double StripeCustomer, subscriptions: [subscription] }
      let(:subscription) { double StripeSubscription, cancel: nil }

      before do
        allow(StripeCustomer).to receive(:find) { stripe_customer }
      end

      it 'deactivates the account' do
        instance.call
        account.reload
        expect(account).to_not be_active
      end

      it 'cancels the subscriptions' do
        instance.call
        expect(subscription).to have_received :cancel
      end

      context 'when the account has no stripe_id' do
        let(:account) { create :account, stripe_id: nil }

        it 'does not try to cancel subscriptions' do
          expect(StripeCustomer).to_not receive :find
          instance.call
        end
      end
    end
  end
end
