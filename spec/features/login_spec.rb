require 'spec_helper'

feature 'logging in' do
  scenario 'with valid credentials' do
    account = create :account, :with_subscription
    user = create :user, {
      username: 'thedude',
      email: 'dude@lebowski.me',
      password: 'thedudeabides',
      account: account
    }

    visit '/users/sign_in'

    fill_in 'Username', with: 'thedude'
    fill_in 'Password', with: 'thedudeabides'
    click_button 'Log in'

    expect(page).to have_current_path "/accounts/#{user.account_id}"
    expect(page).to have_css '[data-test="flash-success"]', text: 'Signed in successfully.'
    expect(page).to have_link 'Logout'

    click_link 'Logout'

    expect(page).to have_css '[data-test="flash-success"]', text: 'Signed out successfully.'
    expect(page).to have_current_path '/users/sign_in'
  end

  scenario 'with invalid credentials' do
    visit '/users/sign_in'

    fill_in 'Username', with: 'foo'
    fill_in 'Password', with: 'bar'
    click_button 'Log in'

    expect(page).to have_current_path '/users/sign_in'
    expect(page).to have_css '[data-test="flash-alert"]', text: 'Invalid Username or password'
  end

  scenario 'with an inactive account' do
    account = create :account, active: false
    user = create :user, {
      username: 'thedude',
      email: 'dude@lebowski.me',
      password: 'thedudeabides',
      account: account
    }

    login user

    expect(page).to have_current_path '/users/sign_in'
    expect(page).to have_css '[data-test="flash-alert"]', text: 'Your account is not active'
  end

  scenario 'as super admin' do
    super_admin = create :user, :super_admin, {
      username: 'thedude',
      email: 'dude@lebowski.me',
      password: 'thedudeabides'
    }

    visit '/users/sign_in'

    fill_in 'Username', with: 'thedude'
    fill_in 'Password', with: 'thedudeabides'
    click_button 'Log in'

    expect(page).to have_css '[data-test="flash-success"]', text: 'Signed in successfully.'
    expect(page).to have_link 'Logout'

    click_link 'Logout'

    expect(page).to have_css '[data-test="flash-success"]', text: 'Signed out successfully.'
    expect(page).to have_current_path '/users/sign_in'
  end
end
