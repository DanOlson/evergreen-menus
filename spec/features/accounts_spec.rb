require 'spec_helper'

feature 'account management' do
  let(:account) { create :account, name: 'Green Plate, LLC' }
  let(:user) { create :user, account: account }

  context 'authenticated' do
    before do
      e1 = create :establishment, name: "Bar 1", account: account
      e2 = create :establishment, name: "Bar 2", account: account
      user.establishments << e1
      user.establishments << e2

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

  context 'unauthenticated' do
    before do
      ActionMailer::Base.deliveries.clear
    end

    scenario 'user can reset their password to recover account access' do
      visit '/users/sign_in'
      click_link 'Forgot your password?'

      fill_in 'Email', with: user.email
      find('[data-test="send-reset-password-instructions"]').click

      email = ActionMailer::Base.deliveries.first.body.raw_source
      reset_password_link = email.match(/href="(.*)"/).captures.first
      visit reset_password_link

      fill_in 'New password', with: 'password123'
      fill_in 'Confirm new password', with: 'password123'
      find('[data-test="reset-password"]').click

      expect(page).to have_css '.alert-success', text: 'Your password has been changed successfully. You are now signed in.'
    end
  end
end
