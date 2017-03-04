shared_context type: :feature do
  def login(user, username: user.username, password: user.password)
    visit '/users/sign_in'

    fill_in 'Username', with: username
    fill_in 'Password', with: password
    click_button 'Log in'
  end
end
