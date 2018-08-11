require 'spec_helper'

describe Entitlements do
  let(:account) { create :account }
  let(:plan) { create :plan }
  let(:instance) { Entitlements.new(account) }

  describe '#entitled_to?' do
    subject { instance.entitled_to? privilege }

    describe ':new_establishment' do
      let(:privilege) { :new_establishment }

      before do
        Subscription.create!({
          plan: plan,
          account: account,
          quantity: quantity,
          status: status,
          remote_id: 'sub_foo'
        })
      end

      context 'when the subscription is "active"' do
        let(:status) { :active }

        context 'and the account has fewer establishments than its subscription allows' do
          let(:quantity) { 2 }

          before do
            create :establishment, account: account
          end

          it { is_expected.to eq true }
        end

        context 'and the account has reached the limit of its subscription' do
          let(:quantity) { 1 }

          before do
            create :establishment, account: account
          end

          it { is_expected.to eq false }
        end
      end

      context 'when the subscription is "pending_initial_payment"' do
        let(:status) { :pending_initial_payment }

        context 'and the account has fewer establishments than its subscription allows' do
          let(:quantity) { 2 }

          before do
            create :establishment, account: account
          end

          it { is_expected.to eq true }
        end

        context 'and the account has reached the limit of its subscription' do
          let(:quantity) { 1 }

          before do
            create :establishment, account: account
          end

          it { is_expected.to eq false }
        end
      end

      context 'when the subscription is "canceled"' do
        let(:status) { :canceled }

        context 'and the account has fewer establishments than its subscription allows' do
          let(:quantity) { 2 }

          before do
            create :establishment, account: account
          end

          it { is_expected.to eq false }
        end

        context 'and the account has reached the limit of its subscription' do
          let(:quantity) { 1 }

          before do
            create :establishment, account: account
          end

          it { is_expected.to eq false }
        end
      end

      context 'when the subscription is "inactive"' do
        let(:status) { :inactive }

        context 'and the account has fewer establishments than its subscription allows' do
          let(:quantity) { 2 }

          before do
            create :establishment, account: account
          end

          it { is_expected.to eq false }
        end

        context 'and the account has reached the limit of its subscription' do
          let(:quantity) { 1 }

          before do
            create :establishment, account: account
          end

          it { is_expected.to eq false }
        end
      end
    end

    context 'with unknown privilege' do
      let(:privilege) { :foo }

      it { is_expected.to eq false }
    end
  end

  describe '#validate!' do
    before do
      Subscription.create!({
        plan: plan,
        account: account,
        quantity: quantity,
        status: :active,
        remote_id: 'sub_foo'
      })
      create :establishment, account: account
    end

    context 'when entitled' do
      let(:quantity) { 2 }

      it 'doesn\'t raise' do
        expect {
          instance.validate! :new_establishment
        }.to_not raise_exception
      end
    end

    context 'when not entitled' do
      let(:quantity) { 1 }

      it 'raises an EntitlementException' do
        expect {
          instance.validate! :new_establishment
        }.to raise_exception NewEstablishmentEntitlementException, 'Your subscription does not allow new establishments at this time.'
      end
    end
  end
end
