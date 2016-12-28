require 'spec_helper'

feature 'establishment management' do
  let(:user) { create :user }

  scenario 'creating an establishment' do
    login user
    click_link "Add an establishment"

    fill_in "Name", with: "The Lanes"
    fill_in "Url", with: "http://thelanes.com/beer-menu"
    fill_in "Street Address", with: "123 Freemont Ave"
    fill_in "City", with: "Encino"
    select "California", from: "State"
    fill_in "Postal Code", with: "91316"
    click_button "Create"

    expect(page).to have_current_path "/accounts/#{user.account_id}"
    expect(page).to have_css "div.notice", text: "Establishment created"
    expect(page).to have_selector "li", text: "The Lanes"
  end

  scenario 'editing an establishment' do
    establishment = create :establishment, account: user.account
    login user

    click_link establishment.name

    fill_in "Name", with: "Sobchak Security"
    fill_in "Url", with: "http://sobsec.com/beer-menu"
    fill_in "Street Address", with: "15 EmPeeAich Ave"
    fill_in "City", with: "Encino"
    select "California", from: "State"
    fill_in "Postal Code", with: "91316"
    click_button "Update"

    expect(page).to have_current_path "/accounts/#{user.account_id}/establishments/#{establishment.id}/edit"
    expect(page).to have_css "div.notice", text: "Establishment updated"
    expect(page).to have_selector "input[value='Sobchak Security']"
  end

  scenario "editing an establishment's beer list", :js, :admin do
    establishment = create :establishment, account: user.account
    login user

    click_link establishment.name
    expect(all('input[data-test="beer"]').size).to eq 0

    find('[data-test="add-beer"]').click
    find('input[data-test="beer"]').set('Bear Republic Racer 5')

    click_button 'Update'
    expect(page).to have_css "div.notice", text: "Establishment updated"
    expect(all('input[data-test="beer"]').size).to eq 1
  end
end
