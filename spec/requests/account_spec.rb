require 'spec_helper'

describe 'accounts' do
  let(:account) { create :account, :with_subscription, stripe_id: 'cus_DHp2EbahQyQruN' }
  let(:user) { create :user, :account_admin, account: account }

  before do
    sign_in user
  end

  describe 'root path redirect' do
    it 'root path redirects to account details page' do
      get '/'
      expect(response).to redirect_to account_path(account)
    end
  end

  describe 'PATCH to /accounts/:id', :vcr do
    before do
      patch account_path(account), params: params
    end

    context 'with valid params' do
      let(:params) do
        {
          id: account.id,
          account: { name: 'Foobar' },
          stripe: { source: 'tok_1D4HcDFuGCUWqFqFJMjMeF0I' }
        }
      end

      it 'updates the account' do
        expect(response).to redirect_to account_path(account)
        follow_redirect!
        expect(response).to have_http_status :ok
        expect(response.body).to_not include 'You are not authorized to access this page'
        expect(account.reload.name).to eq 'Foobar'
      end
    end

    context 'with invalid params' do
      let(:params) do
        {
          id: account.id,
          account: { name: 'Foobar' },
          stripe: { source: '' }
        }
      end

      it 'reports an error' do
        expect(response).to have_http_status :ok
        expect(response.body).to include "Payment info could not be updated"
        expect(account.reload.name).to eq 'Foobar'
      end
    end
  end
end
