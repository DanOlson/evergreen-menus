require 'spec_helper'

feature 'logging in' do
  scenario 'with valid credentials' do
    user = create :user, {
      username: 'thedude',
      email: 'dude@lebowski.me',
      password: 'thedudeabides'
    }

    visit '/users/sign_in'

    fill_in 'Username', with: 'thedude'
    fill_in 'Password', with: 'thedudeabides'
    click_button 'Log in'

    expect(page).to have_current_path "/accounts/#{user.account_id}"
    expect(page).to have_content 'Signed in successfully.'
    expect(page).to have_link 'Logout'

    click_link 'Logout'

    expect(page).to have_content 'Signed out successfully.'
    expect(page).to have_link 'Login'
  end

  scenario 'with invalid credentials' do
    visit '/users/sign_in'

    fill_in 'Username', with: 'foo'
    fill_in 'Password', with: 'bar'
    click_button 'Log in'

    expect(page).to have_current_path '/users/sign_in'
    expect(page).to have_content 'Invalid Username or password'
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
    expect(page).to have_content 'Your account is not active'
  end
end
