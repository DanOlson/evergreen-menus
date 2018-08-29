require 'spec_helper'

describe AccountUpdateService do
  describe '.call' do
    it 'delegates to a new instance' do
      instance = instance_double AccountUpdateService
      ability = instance_double Ability
      account = instance_double Account
      expect(instance).to receive(:call).with({ foo: :bar })
      expect(AccountUpdateService).to receive(:new).with({
        account: account,
        ability: ability
      }) { instance }
      AccountUpdateService.call({
        account: account,
        ability: ability,
        foo: :bar
      })
    end
  end

  describe '#call' do
    let(:instance) do
      AccountUpdateService.new({
        account: account,
        ability: ability,
        stripe_customer: stripe_customer,
        logger: logger
      })
    end
    let(:ability) { instance_double Ability, can?: false }
    let(:account) { create :account, active: false }
    let(:stripe_customer) { double 'StripeCustomer' }
    let(:logger) { double }

    it 'returns self' do
      result = instance.call name: 'foo'
      expect(result).to eq instance
    end

    context 'when the payment information is not being updated' do
      it 'updates the instance' do
        instance.call name: 'Foobar'
        expect(account.name).to eq 'Foobar'
      end

      describe 'updating active status' do
        before do
          allow(ability).to receive(:can?).with(:activate, account) { permission }
        end

        context 'when the ability has permission' do
          let(:permission) { true }

          it 'updates the active status' do
            instance.call active: true
            expect(account).to be_active
          end
        end

        context 'when the ability does not have permission' do
          let(:permission) { false }

          it 'does not update the active status' do
            instance.call active: true
            expect(account).to_not be_active
          end
        end
      end
    end

    context 'when the payment information is being updated' do
      context 'and the account has a Stripe id' do
        let(:account) { create :account, stripe_id: 'cus_somestripeid' }

        it 'updates the payment info for the customer' do
          expect(stripe_customer)
            .to receive(:update)
            .with 'cus_somestripeid', { source: 'tok_fake' }

          instance.call stripe: { source: 'tok_fake' }
        end

        context 'but the Stripe customer is not found' do
          before do
            allow(stripe_customer).to receive(:update).and_raise(StripeCustomer::InvalidRequestError)
          end

          it 'logs an issue' do
            expected = 'No Stripe customer found for "cus_somestripeid"'
            expect(logger).to receive(:error).with expected
            instance.call stripe: { source: 'tok_fake' }
          end
        end

        context 'but the Stripe options are empty' do
          it 'makes no Stripe update' do
            expect(stripe_customer).to_not receive :update

            instance.call stripe: {}
          end
        end
      end

      context 'and the account does not have a Stripe id' do
        it 'makes no Stripe update' do
          expect(stripe_customer).to_not receive :update

          instance.call stripe: { source: 'tok_fake' }
        end
      end
    end
  end

  describe '#success?' do
    let(:ability) { instance_double Ability, can?: false }
    let(:account) { create :account, active: false, stripe_id: 'cus_123' }
    let(:stripe_customer) { double 'StripeCustomer' }
    let(:instance) do
      AccountUpdateService.new({
        account: account,
        ability: ability,
        stripe_customer: stripe_customer
      })
    end

    it 'is false by default' do
      expect(instance).to_not be_success
    end

    context 'when called successfully' do
      subject do
        instance.call name: 'Foo'
      end

      it { is_expected.to be_success }
    end

    context 'when the account is invalid' do
      subject do
        instance.call name: nil
      end

      it { is_expected.to_not be_success }
    end

    context 'when Stripe update fails' do
      subject do
        instance.call name: 'Johnny', stripe: { source: 'tok_fake' }
      end

      before do
        expect(stripe_customer).to receive(:update).and_raise(StripeCustomer::InvalidRequestError)
      end

      it { is_expected.to_not be_success }
    end
  end

  describe '#errors' do
    let(:ability) { instance_double Ability, can?: false }
    let(:account) { create :account, active: false, stripe_id: 'cus_123' }
    let(:stripe_customer) { double 'StripeCustomer' }
    let(:instance) do
      AccountUpdateService.new({
        account: account,
        ability: ability,
        stripe_customer: stripe_customer
      })
    end

    it 'delegates to the account' do
      expect(account).to receive(:errors)
      instance.errors
    end

    context 'when Stripe update fails' do
      before do
        expect(stripe_customer).to receive(:update).and_raise(StripeCustomer::InvalidRequestError)
        instance.call name: 'Johnny', stripe: { source: '' }
      end

      it 'represents an issue with Stripe' do
        expect(instance.errors[:payment]).to eq ['info could not be updated']
      end
    end
  end

  describe '#error_messages' do
    let(:instance) do
      AccountUpdateService.new({
        account: account,
        ability: ability
      })
    end
    let(:account) { build :account }
    let(:ability) { instance_double Ability }

    before do
      account.errors.add :name, "can't be blank"
    end

    it 'returns the full messages' do
      expect(instance.error_messages).to eq ["Name can't be blank"]
    end
  end
end
