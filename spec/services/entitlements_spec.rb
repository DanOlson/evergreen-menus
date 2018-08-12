require 'spec_helper'

describe Entitlements do
  let(:account) { create :account }
  let(:plan) { create :plan }
  let(:instance) { Entitlements.new(account) }

  describe '#entitled_to?' do
    subject { instance.entitled_to? privilege }

    describe :new_establishment do
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

    shared_examples_for 'web integration entitlements' do
      before do
        Subscription.create!({
          plan: plan,
          account: account,
          quantity: 1,
          status: status,
          remote_id: 'sub_foo'
        })
      end

      context 'with tier_1 plan' do
        let(:plan) { create :plan, :tier_1 }

        context 'when the subscription is "active"' do
          let(:status) { :active }
          it { is_expected.to eq false }
        end

        context 'when the subscription is "pending_initial_payment"' do
          let(:status) { :pending_initial_payment }
          it { is_expected.to eq false }
        end

        context 'when the subscription is "canceled"' do
          let(:status) { :canceled }
          it { is_expected.to eq false }
        end

        context 'when the subscription is "inactive"' do
          let(:status) { :inactive }
          it { is_expected.to eq false }
        end
      end

      context 'with tier_2 plan' do
        let(:plan) { create :plan, :tier_2 }

        context 'when the subscription is "active"' do
          let(:status) { :active }
          it { is_expected.to eq true }
        end

        context 'when the subscription is "pending_initial_payment"' do
          let(:status) { :pending_initial_payment }
          it { is_expected.to eq true }
        end

        context 'when the subscription is "canceled"' do
          let(:status) { :canceled }
          it { is_expected.to eq false }
        end

        context 'when the subscription is "inactive"' do
          let(:status) { :inactive }
          it { is_expected.to eq false }
        end
      end

      context 'with tier_3 plan' do
        let(:plan) { create :plan, :tier_3 }

        context 'when the subscription is "active"' do
          let(:status) { :active }
          it { is_expected.to eq true }
        end

        context 'when the subscription is "pending_initial_payment"' do
          let(:status) { :pending_initial_payment }
          it { is_expected.to eq true }
        end

        context 'when the subscription is "canceled"' do
          let(:status) { :canceled }
          it { is_expected.to eq false }
        end

        context 'when the subscription is "inactive"' do
          let(:status) { :inactive }
          it { is_expected.to eq false }
        end
      end
    end

    describe :google_my_business do
      let(:privilege) { :google_my_business }

      it_behaves_like 'web integration entitlements'
    end

    describe :facebook do
      let(:privilege) { :facebook }

      it_behaves_like 'web integration entitlements'
    end

    describe :online_menu do
      let(:privilege) { :online_menu }

      it_behaves_like 'web integration entitlements'
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
