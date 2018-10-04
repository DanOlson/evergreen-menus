require 'spec_helper'

describe 'accounts/edit' do
  before do
    allow(view).to receive(:can?) { false }
    allow(view).to receive(:current_user) { build :user, :account_admin, account: account }
    allow(view).to receive(:after_sign_in_path_for) { '' }
    assign :account, account
    render
  end

  context 'when the account has a stripe_id' do
    let(:account) do
      acct = build :account, id: 1, stripe_id: 'customer'
      allow(acct).to receive(:credit_card_info) { 'Visa ending in 4242' }
      acct
    end

    it 'has a credit card form' do
      account_form = Capybara::Node::Simple.new rendered
      expect(account_form).to have_selector '[data-test="payment-card-info"]'
    end
  end

  context 'when the account does not have a stripe_id' do
    let(:account) { build :account, id: 1 }

    it 'has no credit card form' do
      account_form = Capybara::Node::Simple.new rendered
      expect(account_form).to have_no_selector '[data-test="payment-card-info"]'
    end
  end
end
