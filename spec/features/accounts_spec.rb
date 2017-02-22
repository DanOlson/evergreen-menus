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
        click_link 'Staff'
      end

      context 'with admin role' do
        let(:user) { create :user, :manager, account: account }

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

    describe 'adding staff' do
      let(:user) { create :user, :manager, account: account }

      before do
        ActionMailer::Base.deliveries.clear
      end

      scenario 'admin can invite staff' do
        click_link 'Staff'

        invitations = find_all('[data-test="staff-member-invited"]')
        expect(invitations.size).to eq 0

        click_link 'Invite staff'

        fill_in 'First name', with: 'Donny'
        fill_in 'Last name', with: 'Kerabatsos'
        fill_in 'Email', with: 'donny@lebowski.me'

        check 'Invite another'

        click_button 'Invite'

        expect(page).to have_content "Invitation sent to donny@lebowski.me"

        fill_in 'First name', with: 'Walter'
        fill_in 'Last name', with: 'Sobchak'
        fill_in 'Email', with: 'walter@lebowski.me'

        uncheck 'Invite another'

        click_button 'Invite'

        expect(page).to have_content "Invitation sent to walter@lebowski.me"

        invitations = find_all('[data-test="staff-member-invited"]')
        expect(invitations.size).to eq 2

        expect(ActionMailer::Base.deliveries.size).to eq 2
        donny_invite, walter_invite = ActionMailer::Base.deliveries

        expect(donny_invite.to).to eq ['donny@lebowski.me']
        expect(walter_invite.to).to eq ['walter@lebowski.me']
      end

      scenario 'invited users can register' do
        click_link 'Staff'

        invitations = find_all('[data-test="staff-member-invited"]')
        expect(invitations.size).to eq 0

        click_link 'Invite staff'

        fill_in 'First name', with: 'Maude'
        fill_in 'Last name', with: 'Lebowski'
        fill_in 'Email', with: 'maude@lebowski.me'

        click_button 'Invite'

        expect(page).to have_content "Invitation sent to maude@lebowski.me"

        click_link 'Logout'

        invitation = ActionMailer::Base.deliveries.last
        message = invitation.text_part.decoded
        registration_link = message.match(/link:\s(.*)$/).captures.first

        visit URI(registration_link).path

        fill_in 'Password', with: 'myPassword123'
        fill_in 'Password confirmation', with: 'myPassword123'
        click_button 'Register'

        expect(page).to have_content 'Welcome, Maude!'
        expect(page).to have_current_path "/accounts/#{account.id}"
      end
    end
  end
end
