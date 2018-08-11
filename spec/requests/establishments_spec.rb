require 'spec_helper'

describe 'establishments' do
  let(:account) { create :account }
  let(:user) { create :user, account: account }

  describe 'POST to /accounts/:account_id/establishments' do
    before do
      sign_in user
    end

    it 'root path redirects to account details page' do
      post account_establishments_path(account), params: {
        establishment: {
          name: 'Foo',
          url: 'foo.bar'
        }
      }
      expect(response).to redirect_to account_path(account)
      follow_redirect!
      expect(response.body).to include 'Your subscription does not allow new establishments at this time.'
    end
  end
end
