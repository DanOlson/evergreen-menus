require 'spec_helper'

describe 'staff management' do
  let(:account) { create :account, :with_subscription }
  let!(:staff_member) do
    create :user, {
      account: account,
      first_name: 'Walter',
      last_name: 'Sobchak',
      email: 'walter@lebowski.me',
      password: 'password'
    }
  end

  scenario "admin can change the role of an account's users", :js, :admin do
    establishment = create :establishment, account: account
    staff_member.establishments << establishment

    admin = create :user, :admin
    login admin
    visit "/accounts/#{account.id}/staff"

    list = PageObjects::Admin::StaffList.new
    list.member_named('Walter Sobchak').click

    form = PageObjects::Admin::StaffForm.new

    expect(form).to be_displayed
    form.wait_until_establishment_access_checkboxes_visible

    form.select_role 'manager'
    form.wait_until_establishment_access_checkboxes_invisible
    form.submit

    expect(page).to have_css '[data-test="flash-success"]', text: 'Updated Walter Sobchak'
    expect(list).to be_displayed

    staff_member.reload
    expect(staff_member.role).to eq Role.manager
  end

  scenario 'manager can change role of other staff members', :js, :admin do
    establishment = create :establishment, account: account
    staff_member.establishments << establishment

    manager = create :user, :manager, account: account
    login manager
    click_link 'Staff'

    list = PageObjects::Admin::StaffList.new
    list.member_named('Walter Sobchak').click

    form = PageObjects::Admin::StaffForm.new

    expect(form).to be_displayed

    form.select_role 'manager'
    form.wait_until_establishment_access_checkboxes_invisible
    form.submit

    expect(page).to have_css '[data-test="flash-success"]', text: 'Updated Walter Sobchak'
    expect(list).to be_displayed

    staff_member.reload
    expect(staff_member.role).to eq Role.manager

    list.member_named('Walter Sobchak').click
    form.select_role 'staff'
    form.wait_until_establishment_access_checkboxes_visible
    form.submit

    expect(page).to have_css '.alert-success', text: 'Updated Walter Sobchak'
    expect(list).to be_displayed

    staff_member.reload
    expect(staff_member.role).to eq Role.staff
  end

  scenario 'manager can grant and revoke staff members access to establishments' do
    manager = create :user, :manager, account: account

    establishment_1 = create :establishment, account: account
    establishment_2 = create :establishment, account: account
    ##
    # Assert staff has no visibility
    login staff_member
    account_page = PageObjects::Admin::AccountDetails.new
    expect(account_page.establishments.size).to eq 0
    logout

    login manager
    click_link 'Staff'

    list = PageObjects::Admin::StaffList.new
    list.member_named('Walter Sobchak').click

    form = PageObjects::Admin::StaffForm.new

    expect(form).to be_displayed

    form.grant_establishment_access establishment_1
    form.grant_establishment_access establishment_2
    form.submit

    logout

    login staff_member
    account_page = PageObjects::Admin::AccountDetails.new
    expect(account_page.establishments.size).to eq 2
    expect(account_page).to have_establishment establishment_1.name
    expect(account_page).to have_establishment establishment_2.name

    logout

    login manager
    click_link 'Staff'

    list = PageObjects::Admin::StaffList.new
    list.member_named('Walter Sobchak').click

    form = PageObjects::Admin::StaffForm.new

    expect(form).to be_displayed

    form.revoke_establishment_access establishment_1
    form.submit

    logout

    login staff_member
    account_page = PageObjects::Admin::AccountDetails.new
    expect(account_page.establishments.size).to eq 1
    expect(account_page).to have_establishment establishment_2.name
  end

  scenario 'manager can revoke staff account access (delete user)', :js, :admin do
    manager = create :user, :manager, account: account

    login manager

    click_link 'Staff'
    staff_list = PageObjects::Admin::StaffList.new

    staff_list.member_named('Walter Sobchak').click

    form = PageObjects::Admin::StaffForm.new

    expect(form).to be_displayed
    form.delete

    expect(staff_list).to be_displayed
    expect(staff_list).to_not have_member_named('Walter Sobchak')

    expect(page).to have_css '[data-test="flash-success"]', text: 'Walter Sobchak has been deleted'
  end

  scenario 'staff members cannot view staff list or edit other staff members' do
    other_user = create :user, account: account

    login staff_member
    expect(page).to_not have_link 'Staff'

    list = PageObjects::Admin::StaffList.new
    list.load(account_id: staff_member.account_id)

    expect(list).to_not be_displayed
    expect(page).to have_css '[data-test="flash-alert"]', text: 'You are not authorized to access this page'

    form = PageObjects::Admin::StaffForm.new
    form.load(account_id: account.id, staff_id: other_user.id)
    expect(form).to_not be_displayed
    expect(page).to have_css '[data-test="flash-alert"]', text: 'You are not authorized to access this page'
  end
end
