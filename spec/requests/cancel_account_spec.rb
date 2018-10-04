require 'spec_helper'

describe 'cancel account', :vcr do
  let(:plan) { create :plan }

  context 'when the account is found' do
    let(:user) { create :user, :account_admin, account: account }

    context 'and has a stripe_id' do
      let(:account) { create :account, stripe_id: customer.id }
      let(:customer) do
        StripeCustomer.create({
          email: 'donny@lebowski.me',
          source: 'tok_1D5lLwFuGCUWqFqFtIVheyyu'
        })
      end

      before do
        StripeSubscription.create({
          customer: customer,
          plan: plan,
          quantity: 1
        })
        sign_in user
      end

      it 'cancels the account, logs the user out, and redirects to evergreenmenus.com' do
        post account_cancellation_path(account), params: {
          cancel_account: {
            reason: "We're closing down"
          }
        }
        expect(response).to redirect_to 'https://evergreenmenus.com'
        account.reload
        expect(account).to_not be_active
        expect(customer.subscriptions).to all satisfy { |s| s.status == 'canceled' }
        authenticated = request.env['warden'].authenticated? :user
        expect(authenticated).to eq false
      end
    end

    context 'and has no stripe_id' do
      let(:account) { create :account, stripe_id: nil }

      before do
        sign_in user
      end

      it 'deactivates the account, logs the user out, and redirects to evergreenmenus.com' do
        post account_cancellation_path(account), params: {
          cancel_account: {
            reason: "We're closing down"
          }
        }
        expect(response).to redirect_to 'https://evergreenmenus.com'
        account.reload
        expect(account).to_not be_active
        authenticated = request.env['warden'].authenticated? :user
        expect(authenticated).to eq false
      end
    end

    context 'when the user is not allowed' do
      let(:account) { create :account, stripe_id: nil }
      let(:user) { create :user, account: account }

      before do
        sign_in user
      end

      it 'redirects to account details page' do
        post account_cancellation_path(account), params: {
          cancel_account: {
            reason: "We're closing down"
          }
        }
        expect(response).to redirect_to account_path(account)
        follow_redirect!
        expect(response.body).to match /not authorized/
      end
    end
  end
end
