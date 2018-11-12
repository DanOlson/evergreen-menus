require 'spec_helper'

feature 'redirecting to requested path after logging in', :admin, :js do
  scenario 'when logged out, requested path is remembered and the user is redirected there after login' do
    account = create :account, :with_subscription
    user = create :user, :account_admin, {
      username: 'thedude',
      email: 'dude@lebowski.me',
      password: 'thedudeabides',
      account: account
    }
    staff_list = PageObjects::Admin::StaffList.new
    staff_list.load account_id: account.id

    expect(staff_list).to_not be_displayed
    expect(current_path).to eq '/users/sign_in'

    fill_in 'Username', with: 'thedude'
    fill_in 'Password', with: 'thedudeabides'
    click_button 'Log in'

    expect(staff_list).to be_displayed
  end

  scenario 'requested path is forgotten if the user is not authorized to access it' do
    account = create :account, :with_subscription
    user = create :user, {
      username: 'thedude',
      email: 'dude@lebowski.me',
      password: 'thedudeabides',
      account: account
    }
    staff_list = PageObjects::Admin::StaffList.new
    staff_list.load account_id: account.id

    expect(staff_list).to_not be_displayed
    expect(current_path).to eq '/users/sign_in'

    fill_in 'Username', with: 'thedude'
    fill_in 'Password', with: 'thedudeabides'
    click_button 'Log in'

    expect(staff_list).to_not be_displayed
    account_details = PageObjects::Admin::AccountDetails.new
    expect(account_details).to be_displayed
  end

  scenario 'requested path is forgotten if the user is not entitled to access it' do
    account = create :account
    plan = create :plan, :tier_1
    Subscription.create!({
      account: account,
      plan: plan,
      quantity: 1,
      status: :active,
      remote_id: 'sub_123'
    })
    user = create :user, :account_admin, {
      username: 'thedude',
      email: 'dude@lebowski.me',
      password: 'thedudeabides',
      account: account
    }
    establishment = create :establishment, account: account
    online_menu = create :online_menu, establishment: establishment
    account.establishments << establishment

    login user

    establishment_form = PageObjects::Admin::EstablishmentForm.new
    establishment_form.load(account_id: account.id, establishment_id: establishment.id)
    expect(establishment_form).to be_displayed

    online_menu_form = PageObjects::Admin::OnlineMenuForm.new
    online_menu_form.load({
      account_id: account.id,
      establishment_id: establishment.id,
      online_menu_id: online_menu.id
    })

    expect(online_menu_form).to_not be_displayed
    account_details = PageObjects::Admin::AccountDetails.new
    expect(account_details).to be_displayed
  end
end
