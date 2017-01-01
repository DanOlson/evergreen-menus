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
    expect(all('input[data-test="beer-name-input"]').size).to eq 0

    add_beer_button = find('[data-test="add-beer"]')

    add_beer_button.click
    find('[data-test="beer-name-input-0"]').set('Bear Republic Racer 5')
    add_beer_button.click
    find('[data-test="beer-name-input-1"]').set('Indeed Day Tripper')
    add_beer_button.click
    find('[data-test="beer-name-input-2"]').set('Deschutes Fresh Squeezed')

    click_button 'Update'
    expect(page).to have_css "div.notice", text: "Establishment updated"
    expect(all('[data-test="beer-name-input"]').size).to eq 3

    beers = establishment.beers.map &:name
    expect(beers).to match_array [
      'Bear Republic Racer 5',
      'Indeed Day Tripper',
      'Deschutes Fresh Squeezed'
    ]

    find("[data-test='remove-beer-0']").click
    expect(page).to have_css(".remove-beer[data-test='beer-0']")

    click_button 'Update'
    expect(page).to have_css "div.notice", text: "Establishment updated"
    expect(all('[data-test="beer-name-input"]').size).to eq 2
  end

  scenario 'unsaved beers can be deleted from the UI', :js, :admin do
    establishment = create :establishment, account: user.account
    login user

    click_link establishment.name
    find('[data-test="add-beer"]').click

    expect(all('[data-test="beer-name-input-0"]').size).to eq 1
    find("[data-test='remove-beer-0']").click
    expect(all('[data-test="beer-name-input-0"]').size).to eq 0
  end
end
