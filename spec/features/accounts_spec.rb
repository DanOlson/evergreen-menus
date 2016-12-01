require 'spec_helper'

feature 'account management' do
  let(:account) { create :account, name: 'Green Plate, LLC' }
  let(:user) { create :user, account: account }

  context 'authenticated' do
    before do
      create :establishment, name: "Bar 1", account: account
      create :establishment, name: "Bar 2", account: account

      login user
    end

    scenario 'user can access their account' do
      expect(page).to have_current_path "/accounts/#{user.account_id}"
      expect(page).to have_content account.name
      expect(page).to have_content "Bar 1"
      expect(page).to have_content "Bar 2"
    end

    scenario 'user cannot access other accounts' do
      other_user = create :user

      visit "/accounts/#{other_user.account_id}"
      expect(page).to have_current_path "/accounts/#{user.account_id}"
      expect(page).to have_content 'You are not authorized to access this page.'
    end
  end
end
