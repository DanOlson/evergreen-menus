shared_context type: :feature do
  def login(user)
    visit '/users/sign_in'

    fill_in 'Username', with: user.username
    fill_in 'Password', with: user.password
    click_button 'Log in'
  end
end
