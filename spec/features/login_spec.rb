require 'spec_helper'

feature 'logging in' do
  scenario 'with valid credentials' do
    User.create!({
      username: 'thedude',
      email: 'dude@lebowski.me',
      password: 'thedudeabides'
    })

    visit '/users/sign_in'

    fill_in 'Username', with: 'thedude'
    fill_in 'Password', with: 'thedudeabides'
    click_button 'Log in'

    expect(page).to have_current_path '/'
  end

  scenario 'with invalid credentials' do
    visit '/users/sign_in'

    fill_in 'Username', with: 'foo'
    fill_in 'Password', with: 'bar'
    click_button 'Log in'

    expect(page).to have_current_path '/users/sign_in'
  end
end
