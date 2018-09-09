module AuthenticationHelper
  def login(user, username: user.username, password: user.password)
    visit '/users/sign_in'

    fill_in 'Username', with: username
    fill_in 'Password', with: password
    click_button 'Log in'
  end

  def logout
    find('[data-test="logout"]').click
  end

  def session_cookie
    cookie = page.send(:driver).cookies['_evergreen_session']
    "_evergreen_session=#{cookie}"
  end
end
