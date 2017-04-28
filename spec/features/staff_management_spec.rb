require 'spec_helper'

describe 'staff management' do
  let(:account) { create :account }
  let!(:staff_member) do
    create :user, {
      account: account,
      first_name: 'Walter',
      last_name: 'Sobchak',
      email: 'walter@lebowski.me',
      password: 'password'
    }
  end

  scenario "admin can change the role of an account's users" do
    admin = create :user, :admin
    login admin
    visit "/accounts/#{account.id}/staff"

    list = PageObjects::Admin::StaffList.new
    list.member_named('Walter Sobchak').click

    form = PageObjects::Admin::StaffForm.new

    expect(form).to be_displayed

    form.select_role 'manager'
    form.submit

    expect(page).to have_css '[data-test="flash-success"]', text: 'Updated Walter Sobchak'
    expect(list).to be_displayed

    staff_member.reload
    expect(staff_member.role).to eq Role.manager
  end

  scenario 'manager can change role of other staff members' do
    manager = create :user, :manager, account: account
    login manager
    click_link 'Staff'

    list = PageObjects::Admin::StaffList.new
    list.member_named('Walter Sobchak').click

    form = PageObjects::Admin::StaffForm.new

    expect(form).to be_displayed

    form.select_role 'manager'
    form.submit

    expect(page).to have_css '[data-test="flash-success"]', text: 'Updated Walter Sobchak'
    expect(list).to be_displayed

    staff_member.reload
    expect(staff_member.role).to eq Role.manager

    list.member_named('Walter Sobchak').click
    form.select_role 'staff'
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

  scenario 'staff members cannot view staff list' do
    login staff_member
    expect(page).to_not have_link 'Staff'

    list = PageObjects::Admin::StaffList.new
    list.load(account_id: staff_member.account_id)

    expect(list).to_not be_displayed
    expect(page).to have_css '[data-test="flash-alert"]', text: 'You are not authorized to access this page'
  end
end