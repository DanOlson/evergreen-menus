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

    describe 'viewing staff' do
      before do
        create :user, {
          first_name: 'Jeffrey',
          last_name: 'Lebowski',
          account: account
        }
        create :user, {
          first_name: 'Walter',
          last_name: 'Sobchak',
          account: account
        }
        visit "/accounts/#{account.id}/staff"
      end

      context 'with admin role' do
        let(:user) { create :user, :admin, account: account }

        scenario 'user can view staff' do
          expect(page).to have_content 'Jeffrey Lebowski'
          expect(page).to have_content 'Walter Sobchak'
        end
      end

      context 'without admin role' do
        scenario 'user cannot view staff' do
          expect(page).to have_current_path "/accounts/#{user.account_id}"
          expect(page).to have_content 'You are not authorized to access this page.'
        end
      end
    end
  end
end
