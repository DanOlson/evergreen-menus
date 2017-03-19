require 'spec_helper'

feature 'establishment management' do
  let(:user) { create :user }

  scenario 'creating an establishment' do
    login user
    find('[data-test="add-establishment"]').click

    fill_in "Name", with: "The Lanes"
    fill_in "Url", with: "http://thelanes.com/beer-menu"
    fill_in "Street", with: "123 Freemont Ave"
    fill_in "City", with: "Encino"
    select "California", from: "State"
    fill_in "Postal Code", with: "91316"
    click_button "Create"

    expect(page).to have_current_path "/accounts/#{user.account_id}"
    expect(page).to have_css "div.alert-success", text: "Establishment created"
    expect(page).to have_selector "[data-test='establishment']", text: "The Lanes"
  end

  scenario 'editing an establishment' do
    establishment = create :establishment, account: user.account
    login user

    click_link establishment.name

    fill_in "Name", with: "Sobchak Security"
    fill_in "Url", with: "http://sobsec.com/beer-menu"
    fill_in "Street", with: "15 EmPeeAich Ave"
    fill_in "City", with: "Encino"
    select "California", from: "State"
    fill_in "Postal Code", with: "91316"
    click_button "Update"

    expect(page).to have_current_path "/accounts/#{user.account_id}/establishments/#{establishment.id}/edit"
    expect(page).to have_css "div.alert-success", text: "Establishment updated"
    expect(page).to have_selector "input[value='Sobchak Security']"
  end

  scenario "editing an establishment's beer list", :js, :admin do
    establishment = create :establishment, account: user.account
    establishment.lists.create!(name: 'Beers')
    login user

    click_link establishment.name
    expect(all('input[data-test="beer-input"]').size).to eq 0

    add_beer_button = find('[data-test="add-beer"]')

    add_beer_button.click
    find('[data-test="beer-name-input-0"]').set('Bear Republic Racer 5')
    add_beer_button.click
    find('[data-test="beer-name-input-1"]').set('Indeed Day Tripper')
    add_beer_button.click
    find('[data-test="beer-name-input-2"]').set('Deschutes Fresh Squeezed')

    click_button 'Update'
    expect(page).to have_css "div.alert-success", text: "Establishment updated"
    expect(all('[data-test="beer-input"]').size).to eq 3

    beers = establishment.beers.map &:name
    expect(beers).to match_array [
      'Bear Republic Racer 5',
      'Indeed Day Tripper',
      'Deschutes Fresh Squeezed'
    ]

    find("[data-test='remove-beer-0']").click
    expect(page).to have_css(".remove-beer[data-test='beer-0']")

    click_button 'Update'
    expect(page).to have_css "div.alert-success", text: "Establishment updated"
    expect(all('[data-test="beer-input"]').size).to eq 2
  end

  scenario "an establishment's beer list can have prices and descriptions", :js, :admin do
    establishment = create :establishment, account: user.account
    establishment.lists.create!(name: 'Beers')
    login user

    click_link establishment.name
    expect(all('input[data-test="beer-input"]').size).to eq 0

    add_beer_button = find('[data-test="add-beer"]')

    add_beer_button.click
    find('[data-test="beer-name-input-0"]').set('Bear Republic Racer 5')
    find('[data-test="beer-price-input-0"]').set('5.5')
    find('[data-test="beer-description-input-0"]').set("A crowd favorite")
    add_beer_button.click
    find('[data-test="beer-name-input-1"]').set('Indeed Day Tripper')
    find('[data-test="beer-price-input-1"]').set('5')
    find('[data-test="beer-description-input-1"]').set("The gold standard")
    add_beer_button.click
    find('[data-test="beer-name-input-2"]').set('Deschutes Fresh Squeezed')
    find('[data-test="beer-price-input-2"]').set('6')
    find('[data-test="beer-description-input-2"]').set("The biggest IPA this side of the Mississippi")

    click_button 'Update'
    expect(page).to have_css "div.alert-success", text: "Establishment updated"
    expect(all('[data-test="beer-input"]').size).to eq 3

    beers = establishment.beers.map { |b| [b.name, b.price_in_cents, b.description] }
    expect(beers).to eq([
      ['Bear Republic Racer 5', 550, 'A crowd favorite'],
      ['Indeed Day Tripper', 500, 'The gold standard'],
      ['Deschutes Fresh Squeezed', 600, 'The biggest IPA this side of the Mississippi']
    ])

    find("[data-test='remove-beer-0']").click
    expect(page).to have_css(".remove-beer[data-test='beer-0']")

    click_button 'Update'
    expect(page).to have_css "div.alert-success", text: "Establishment updated"
    expect(all('[data-test="beer-input"]').size).to eq 2
  end

  scenario 'beers can be removed and unremoved from the beer list', :js, :admin do
    establishment = create :establishment, account: user.account
    establishment.lists.create!(name: 'Beers')
    login user

    click_link establishment.name

    add_beer_button = find('[data-test="add-beer"]')
    add_beer_button.click
    find('[data-test="beer-name-input-0"]').set('Bear Republic Racer 5')
    add_beer_button.click
    find('[data-test="beer-name-input-1"]').set('Indeed Day Tripper')

    click_button 'Update'
    expect(page).to have_css "div.alert-success", text: "Establishment updated"
    expect(all('[data-test="beer-input"]').size).to eq 2

    find("[data-test='remove-beer-0']").click
    find("[data-test='remove-beer-1']").click

    expect(page).to have_css(".remove-beer[data-test='beer-0']")
    expect(page).to have_css(".remove-beer[data-test='beer-1']")

    find("[data-test='keep-beer-1']").click

    expect(page).to_not have_css(".remove-beer[data-test='beer-1']")

    click_button 'Update'
    expect(page).to have_css "div.alert-success", text: "Establishment updated"
    expect(all('[data-test="beer-input"]').size).to eq 1

    input = find '[data-test="beer-name-input-0"]'
    expect(input.value).to eq 'Indeed Day Tripper'
  end

  scenario 'unsaved beers can be deleted from the UI', :js, :admin do
    establishment = create :establishment, account: user.account
    establishment.lists.create!(name: 'Beers')
    login user

    click_link establishment.name
    find('[data-test="add-beer"]').click

    expect(all('[data-test="beer-name-input-0"]').size).to eq 1
    find("[data-test='remove-beer-0']").click
    expect(all('[data-test="beer-name-input-0"]').size).to eq 0
  end

  scenario "beers added to an establishment's list show up in Beermapper", :admin, :js do
    establishment = create :establishment, name: "Lebowski", account: user.account
    establishment.lists.create!(name: 'Beers')
    login user

    click_link establishment.name

    add_beer_button = find('[data-test="add-beer"]')

    add_beer_button.click
    find('[data-test="beer-name-input-0"]').set('Deschutes Pinedrops')
    add_beer_button.click
    find('[data-test="beer-name-input-1"]').set('Deschutes Mirror Pond')
    add_beer_button.click
    find('[data-test="beer-name-input-2"]').set('Deschutes Big Rig')
    add_beer_button.click
    find('[data-test="beer-name-input-3"]').set('Indeed Stir Crazy')
    add_beer_button.click
    find('[data-test="beer-name-input-4"]').set('Surly Stout')
    add_beer_button.click
    find('[data-test="beer-name-input-5"]').set('Budweiser')

    click_button 'Update'
    expect(page).to have_css "div.alert-success", text: "Establishment updated"
    expect(all('[data-test="beer-input"]').size).to eq 6

    visit 'http://test.beermapper.ember'
    fill_in 'search-field', with: 'Deschutes'
    click_button 'Search'

    find('div[title="Lebowski"]').trigger('click')
    within('.map-marker') do
      expect(page).to have_link 'Lebowski'
      expect(page).to have_css 'li', text: 'Deschutes Pinedrops'
      expect(page).to have_css 'li', text: 'Deschutes Mirror Pond'
      expect(page).to have_css 'li', text: 'Deschutes Big Rig'
    end

    click_link 'Lebowski'
    expect(page).to have_css 'li', text: 'Deschutes Pinedrops'
    expect(page).to have_css 'li', text: 'Deschutes Mirror Pond'
    expect(page).to have_css 'li', text: 'Deschutes Big Rig'
    expect(page).to have_css 'li', text: 'Indeed Stir Crazy'
    expect(page).to have_css 'li', text: 'Surly Stout'
    expect(page).to have_css 'li', text: 'Budweiser'
  end

  scenario "beers added to an establishment's list show up on the establishment's website", :admin, :js do
    establishment = create :establishment, name: "The Lanes", account: user.account
    establishment.lists.create!(name: 'Beers')

    Beermapper::Application.load_tasks
    Rake::Task['generate_third_party_site'].invoke

    login user

    click_link establishment.name

    add_beer_button = find('[data-test="add-beer"]')

    add_beer_button.click
    find('[data-test="beer-name-input-0"]').set('Deschutes Pinedrops')
    add_beer_button.click
    find('[data-test="beer-name-input-1"]').set('Deschutes Mirror Pond')
    add_beer_button.click
    find('[data-test="beer-name-input-2"]').set('Deschutes Big Rig')
    add_beer_button.click
    find('[data-test="beer-name-input-3"]').set('Indeed Stir Crazy')
    add_beer_button.click
    find('[data-test="beer-name-input-4"]').set('Surly Stout')
    add_beer_button.click
    find('[data-test="beer-name-input-5"]').set('Budweiser')

    click_button 'Update'
    expect(page).to have_css "div.alert-success", text: "Establishment updated"
    expect(all('[data-test="beer-input"]').size).to eq 6


    visit 'http://test.my-bar.dev'
    expect(page).to have_content 'Deschutes Pinedrops'
    expect(page).to have_content 'Deschutes Mirror Pond'
    expect(page).to have_content 'Deschutes Big Rig'
    expect(page).to have_content 'Indeed Stir Crazy'
    expect(page).to have_content 'Surly Stout'
    expect(page).to have_content 'Budweiser'
  end
end
