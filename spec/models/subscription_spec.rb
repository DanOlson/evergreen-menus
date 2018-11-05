require 'spec_helper'

describe Subscription do
  describe '#trial_strategy' do
    let(:subscription) { Subscription.new }
    subject { subscription.trial_strategy }

    context 'by default' do
      it { is_expected.to eq 'without_credit_card' }
    end

    it 'can be with_credit_card' do
      subscription.trial_strategy = :with_credit_card
      expect(subscription.trial_strategy).to eq 'with_credit_card'
    end

    it 'can\'t just be anything' do
      expect {
        subscription.trial_strategy = 'asdf'
      }.to raise_error ArgumentError
    end
  end

  describe '.current_trial_strategy' do
    subject { Subscription.current_trial_strategy }

    it { is_expected.to eq :without_credit_card }
  end
end
