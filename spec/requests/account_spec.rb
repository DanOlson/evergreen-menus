require 'spec_helper'

describe 'accounts' do
  let(:account) { create :account }
  let(:user) { create :user, account: account }

  context 'when logged in' do
    before do
      sign_in user
    end

    it 'root path redirects to account details page' do
      get '/'
      expect(response).to redirect_to account_path(account)
    end
  end
end
