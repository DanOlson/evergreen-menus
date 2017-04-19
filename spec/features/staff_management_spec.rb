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

  scenario 'staff members cannot view staff list' do
    login staff_member
    expect(page).to_not have_link 'Staff'

    list = PageObjects::Admin::StaffList.new
    list.load(account_id: staff_member.account_id)

    expect(list).to_not be_displayed
    expect(page).to have_css '[data-test="flash-alert"]', text: 'You are not authorized to access this page'
  end
end
