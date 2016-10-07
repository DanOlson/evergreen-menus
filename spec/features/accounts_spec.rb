require 'spec_helper'

feature 'account management' do
  let(:user) { create :user }

  context 'authenticated' do
    before do
      login user
    end

    scenario 'user can access their account' do
      expect(page).to have_current_path "/accounts/#{user.account_id}"
    end

    scenario 'user cannot access other accounts' do
      other_user = create :user

      visit "/accounts/#{other_user.account_id}"
      # expect(page).to_not have_current_path "/accounts/#{other_user.account_id}"
      expect(page).to have_current_path "/accounts/#{user.account_id}"
      expect(page).to have_content 'You are not authorized to access this page.'
    end
  end
end
