require 'spec_helper'

describe 'user profile management' do
  let(:account) { create :account }
  let(:user) do
    create :user, {
      account: account,
      email: 'walter@lebowski.me',
      password: 'password'
    }
  end

  before do
    login user
  end

  scenario 'logged in user can edit their profile' do
    click_link 'Profile'
    fill_in 'Email', with: 'walteristhebest@lebowski.me'
    fill_in 'Current password', with: 'password'
    find('[data-test="edit-user-submit"]').click

    expect(page).to have_css '.alert-success', text: 'Your profile has been updated successfully.'
    user.reload
    expect(user.email).to eq 'walteristhebest@lebowski.me'

    click_link 'Profile'
    fill_in 'user[password]', with: 'drowssap'
    fill_in 'user[password_confirmation]', with: 'drowssap'
    fill_in 'user[current_password]', with: 'password'
    find('[data-test="edit-user-submit"]').click

    expect(page).to have_css '.alert-success', text: 'Your profile has been updated successfully.'

    click_link 'Logout'
    login user, password: 'drowssap'

    expect(page).to have_content 'Signed in successfully.'
  end
end
