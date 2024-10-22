require 'spec_helper'

feature 'account management' do
  let(:account) { create :account, :with_subscription, name: 'Green Plate, LLC' }
  let(:user) { create :user, account: account }
  let(:bar_1) { create :establishment, name: "Bar 1", account: account }
  let(:bar_2) { create :establishment, name: "Bar 2", account: account }

  scenario 'super admin can create, edit, and delete an account', :js, :admin do
    super_admin = create :user, :super_admin
    login super_admin

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
    expect(page).to have_css 'ol.breadcrumb li.active', text: 'Lebowski, Inc.'

    account_details = PageObjects::Admin::AccountDetails.new
    account_details.edit_button.click

    expect(form).to be_displayed
    form.name = 'Lebowski, Incorporated'
    form.submit

    expect(account_details).to be_displayed
    expect(page).to have_css '[data-test="flash-success"]', text: 'Account updated'
    expect(page).to have_css 'ol.breadcrumb li.active', text: 'Lebowski, Incorporated'

    account_details.edit_button.click
    form.delete

    expect(account_list).to be_displayed
    expect(page).to have_css '[data-test="flash-success"]', text: 'Account deleted'
    expect(account_list).to_not have_account_named 'Lebowski, Incorporated'
  end

  scenario 'super admin can invite account admin' do
    ActionMailer::Base.deliveries.clear
    super_admin = create :user, :super_admin
    login super_admin

    invitation_form = PageObjects::Admin::StaffInvitationForm.new
    invitation_form.load(account_id: account.id)
    expect(invitation_form).to be_displayed

    expect(invitation_form).to have_role_input

    invitation_form.first_name = 'Donny'
    invitation_form.last_name  = 'Kerabatsos'
    invitation_form.email      = 'donny@lebowski.me'
    invitation_form.role       = 'admin'

    invitation_form.submit

    expect(page).to have_content "Invitation sent to donny@lebowski.me"

    expect(ActionMailer::Base.deliveries.size).to eq 1

    staff_list = PageObjects::Admin::StaffList.new
    staff_list.invitation_to('Donny Kerabatsos').click

    expect(invitation_form.role).to eq 'admin'

    logout

    invitation = ActionMailer::Base.deliveries.last
    message = invitation.text_part.decoded
    registration_link = message.match(/link:\s(.*)$/).captures.first
    expect(registration_link).to start_with 'http'

    visit URI(registration_link).path

    fill_in 'Password', with: 'myPassword123'
    fill_in 'Password confirmation', with: 'myPassword123'
    click_button 'Register'

    logout

    login super_admin

    staff_list.load(account_id: account.id)
    staff_list.member_named('Donny Kerabatsos').click

    staff_form = PageObjects::Admin::StaffForm.new
    expect(staff_form).to be_displayed
    expect(staff_form.name).to eq 'Donny Kerabatsos'
    expect(staff_form.role).to eq 'admin'
  end

  scenario 'account admin can edit their account, but cannot activate, deactivate or delete it' do
    account_admin = create :user, :account_admin, account: account
    login account_admin

    account_details = PageObjects::Admin::AccountDetails.new
    account_details.edit_button.click

    form = PageObjects::Admin::AccountForm.new
    expect(form).to be_displayed
    expect(form).to have_no_active_input
    expect(form).to have_no_delete_button
  end

  describe 'access to accounts index' do
    scenario 'account admin does not have access' do
      account_admin = create :user, :account_admin, account: account
      login account_admin

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
      let(:user) { create :user, :account_admin, account: account }

      before do
        ActionMailer::Base.deliveries.clear
      end

      scenario 'account admin can invite staff' do
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
        expect(donny_invite.from).to eq ['do-not-reply@evergreenmenus.com']
        expect(walter_invite.from).to eq ['do-not-reply@evergreenmenus.com']
      end

      scenario 'account admin can edit staff invitations' do
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

      scenario 'account admin can delete staff invitations', :js, :admin do
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
        expect(registration_link).to start_with 'http'

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

      scenario 'invited users can be deleted', :js, :admin do
        logout
        invitation = UserInvitation.create!({
          first_name: 'Donny',
          last_name: 'Kerabatsos',
          email: 'donny@lebowski.me',
          account: account,
          inviting_user: user
        })
        invitation.establishments << bar_1
        registration_path = new_invited_registration_path(invitation.to_sgid(for: 'registration'))

        visit registration_path

        fill_in 'Password', with: 'myPassword123'
        fill_in 'Password confirmation', with: 'myPassword123'
        click_button 'Register'

        expect(page).to have_content 'Welcome, Donny!'

        logout

        login user
        click_link 'Staff'

        staff_list = PageObjects::Admin::StaffList.new
        staff_list.member_named('Donny Kerabatsos').click

        staff_form = PageObjects::Admin::StaffForm.new
        expect(staff_form).to be_displayed

        staff_form.delete

        expect(staff_list).to be_displayed
        expect(page).to have_css '[data-test="flash-success"]', text: "Donny Kerabatsos has been deleted"
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

      email = ActionMailer::Base.deliveries.first
      email_body = email.html_part.to_s

      expect(email.from).to eq ['do-not-reply@evergreenmenus.com']

      reset_password_link = email_body.match(/href="(.*)"/).captures.first
      expect(reset_password_link).to start_with 'http'

      visit reset_password_link

      fill_in 'New password', with: 'password123'
      fill_in 'Confirm new password', with: 'password123'
      find('[data-test="reset-password"]').click

      expect(page).to have_css '.alert-success', text: 'Your password has been changed successfully. You are now signed in.'

      logout

      login user, password: 'password123'
      expect(page).to have_css '[data-test="flash-success"]', text: 'Signed in successfully.'
    end
  end

  scenario 'account admin has access to Web Integrations' do
    account_admin = create :user, :account_admin, account: account
    login account_admin

    account_details = PageObjects::Admin::AccountDetails.new
    expect(account_details).to be_displayed
    expect(account_details).to have_web_integrations
  end

  scenario 'staff has no access to Web Integrations' do
    login user

    account_details = PageObjects::Admin::AccountDetails.new
    expect(account_details).to be_displayed
    expect(account_details).to_not have_web_integrations
  end
end
