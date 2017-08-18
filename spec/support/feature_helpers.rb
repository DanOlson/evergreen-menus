shared_context type: :feature do
  require Rails.root.join 'lib/services/third_party_site_generator'

  def login(user, username: user.username, password: user.password)
    visit '/users/sign_in'

    fill_in 'Username', with: username
    fill_in 'Password', with: password
    click_button 'Log in'
  end

  def logout
    find('[data-test="logout"]').click
  end
end
