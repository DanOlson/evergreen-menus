require 'spec_helper'

feature 'account management' do
  let(:account) { create :account, name: 'Green Plate, LLC' }
  let(:user) { create :user, account: account }
  let(:bar_1) { create :establishment, name: "Bar 1", account: account }
  let(:bar_2) { create :establishment, name: "Bar 2", account: account }

  scenario 'admin can create, edit, and delete an account', :js, :admin do
    admin = create :user, :admin
    login admin

    account_list = PageObjects::Admin::AccountsList.new
    account_list.load

    expect(account_list).to have_new_account_button
    account_list.new_account_button.click

    form = PageObjects::Admin::AccountForm.new
    expect(form).to have_active_input
    form.name = 'Lebowski, Inc.'
    form.activate

    form.submit
    expect(page).to have_css '[data-test="flash-success"]', text: 'Account created'
    expect(page).to have_css 'h3', text: 'Lebowski, Inc.'

    account_details = PageObjects::Admin::AccountDetails.new
    account_details.edit_button.click

    expect(form).to be_displayed
    form.name = 'Lebowski, Incorporated'
    form.submit

    expect(account_details).to be_displayed
    expect(page).to have_css '[data-test="flash-success"]', text: 'Account updated'
    expect(page).to have_css 'h3', text: 'Lebowski, Incorporated'

    account_details.edit_button.click
    form.delete

    expect(account_list).to be_displayed
    expect(page).to have_css '[data-test="flash-success"]', text: 'Account deleted'
    expect(account_list).to_not have_account_named 'Lebowski, Incorporated'
  end

  scenario 'manager can edit their account, but cannot activate, deactivate or delete it' do
    manager = create :user, :manager, account: account
    login manager

    account_details = PageObjects::Admin::AccountDetails.new
    account_details.edit_button.click

    form = PageObjects::Admin::AccountForm.new
    expect(form).to be_displayed
    expect(form).to have_no_active_input
    expect(form).to have_no_delete_button
  end

  describe 'access to accounts index' do
    scenario 'manager does not have access' do
      manager = create :user, :manager, account: account
      login manager

      account_list = PageObjects::Admin::AccountsList.new
      account_list.load

      expect(account_list).to_not be_displayed
      expect(page).to have_css '[data-test="flash-alert"]', text: 'You are not authorized to access this page'
    end

    scenario 'staff does not have access' do
      login user

      account_list = PageObjects::Admin::AccountsList.new
      account_list.load

      expect(account_list).to_not be_displayed
      expect(page).to have_css '[data-test="flash-alert"]', text: 'You are not authorized to access this page'
    end
  end

  context 'authenticated' do
    before do
      user.establishments << bar_1
      user.establishments << bar_2

      login user
    end

    scenario 'staff can access their account, but not edit it' do
      account_details = PageObjects::Admin::AccountDetails.new
      expect(account_details).to be_displayed
      expect(account_details).to have_current_path "/accounts/#{user.account_id}"
      expect(account_details.name).to eq account.name
      expect(account_details).to have_establishment 'Bar 1'
      expect(account_details).to have_establishment 'Bar 2'
      expect(account_details).to have_no_edit_button
      visit "/accounts/#{user.account_id}/edit"

      expect(account_details).to be_displayed
      expect(page).to have_css '[data-test=flash-alert]', text: 'You are not authorized to access this page.'
    end

    scenario 'user cannot access other accounts' do
      other_user = create :user

      visit "/accounts/#{other_user.account_id}"
      expect(page).to have_current_path "/accounts/#{user.account_id}"
      expect(page).to have_css '[data-test=flash-alert]', text: 'You are not authorized to access this page.'
    end

    describe 'adding staff' do
      let(:user) { create :user, :manager, account: account }

      before do
        ActionMailer::Base.deliveries.clear
      end

      scenario 'manager can invite staff' do
        click_link 'Staff'

        staff_list = PageObjects::Admin::StaffList.new
        expect(staff_list.invitations.size).to eq 0

        staff_list.invite_staff_button.click

        invitation_form = PageObjects::Admin::StaffInvitationForm.new

        invitation_form.first_name = 'Donny'
        invitation_form.last_name  = 'Kerabatsos'
        invitation_form.email      = 'donny@lebowski.me'
        invitation_form.grant_establishment_access bar_1
        invitation_form.invite_another
        invitation_form.submit

        expect(page).to have_content "Invitation sent to donny@lebowski.me"

        invitation_form.first_name = 'Walter'
        invitation_form.last_name  = 'Sobchak'
        invitation_form.email      = 'walter@lebowski.me'
        invitation_form.dont_invite_another
        invitation_form.submit

        expect(page).to have_content "Invitation sent to walter@lebowski.me"

        staff_list = PageObjects::Admin::StaffList.new
        expect(staff_list.invitations.size).to eq 2

        expect(ActionMailer::Base.deliveries.size).to eq 2
        donny_invite, walter_invite = ActionMailer::Base.deliveries

        expect(donny_invite.to).to eq ['donny@lebowski.me']
        expect(walter_invite.to).to eq ['walter@lebowski.me']
      end

      scenario 'manager can edit staff invitations' do
        click_link 'Staff'

        staff_list = PageObjects::Admin::StaffList.new
        expect(staff_list.invitations.size).to eq 0

        staff_list.invite_staff_button.click

        invitation_form = PageObjects::Admin::StaffInvitationForm.new

        invitation_form.first_name = 'Donny'
        invitation_form.last_name  = 'Kerabatsos'
        invitation_form.email      = 'donny@lebowski.me'
        invitation_form.grant_establishment_access bar_1
        invitation_form.submit

        staff_list = PageObjects::Admin::StaffList.new
        staff_list.invitation_to('Donny Kerabatsos').click

        expect(invitation_form.email_input).to be_disabled
        expect(invitation_form).to be_granted_access_to(bar_1)
        expect(invitation_form).to_not be_granted_access_to(bar_2)

        invitation_form.grant_establishment_access bar_2
        invitation_form.submit

        staff_list.invitation_to('Donny Kerabatsos').click
        expect(invitation_form).to be_granted_access_to(bar_1)
        expect(invitation_form).to be_granted_access_to(bar_2)
      end

      scenario 'manager can delete staff invitations', :js, :admin do
        click_link 'Staff'

        staff_list = PageObjects::Admin::StaffList.new
        expect(staff_list.invitations.size).to eq 0

        staff_list.invite_staff_button.click

        invitation_form = PageObjects::Admin::StaffInvitationForm.new

        invitation_form.first_name = 'Donny'
        invitation_form.last_name  = 'Kerabatsos'
        invitation_form.email      = 'donny@lebowski.me'
        invitation_form.grant_establishment_access bar_1
        invitation_form.submit

        staff_list.invitation_to('Donny Kerabatsos').click

        invitation_form.delete
        expect(page).to have_css '[data-test="flash-success"]', text: 'Invitation deleted'
        expect(staff_list).to_not have_invitation_to('Donny Kerabatsos')
      end

      scenario 'invited users can register' do
        click_link 'Staff'

        staff_list = PageObjects::Admin::StaffList.new
        expect(staff_list.invitations.size).to eq 0

        staff_list.invite_staff_button.click

        invitation_form = PageObjects::Admin::StaffInvitationForm.new

        invitation_form.first_name = 'Maude'
        invitation_form.last_name  = 'Lebowski'
        invitation_form.email      = 'maude@lebowski.me'
        invitation_form.grant_establishment_access bar_1
        invitation_form.submit

        expect(page).to have_content "Invitation sent to maude@lebowski.me"

        logout

        invitation = ActionMailer::Base.deliveries.last
        message = invitation.text_part.decoded
        registration_link = message.match(/link:\s(.*)$/).captures.first

        visit URI(registration_link).path

        fill_in 'Password', with: 'myPassword123'
        fill_in 'Password confirmation', with: 'myPassword123'
        click_button 'Register'

        expect(page).to have_content 'Welcome, Maude!'
        expect(page).to have_current_path "/accounts/#{account.id}"

        account_details = PageObjects::Admin::AccountDetails.new
        expect(account_details).to have_establishment 'Bar 1'
        expect(account_details).to_not have_establishment 'Bar 2'
        expect(account_details.establishments.size).to eq 1

        logout

        login user

        click_link 'Staff'
        expect(staff_list.invitations.size).to eq 0
        expect(staff_list).to have_member_named 'Maude Lebowski'
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
