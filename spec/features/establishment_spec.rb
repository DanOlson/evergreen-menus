require 'spec_helper'

feature 'establishment management' do
  let(:user) { create :user }

  before do
    login user
  end

  scenario 'creating an establishment' do
    click_link "Add an establishment"

    fill_in "Name", with: "The Lanes"
    fill_in "Url", with: "http://thelanes.com/beer-menu"
    fill_in "Street Address", with: "123 Freemont Ave"
    fill_in "City", with: "Encino"
    select "California", from: "State"
    fill_in "Postal Code", with: "91316"
    click_button "Create"

    expect(page).to have_current_path "/accounts/#{user.account_id}"
    expect(page).to have_css "div.notice", text: "Successfully created The Lanes"
    expect(page).to have_selector "li", text: "The Lanes"
  end
end
