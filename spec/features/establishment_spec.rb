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
    login user

    click_link establishment.name
    click_link 'Add List'

    form = PageObjects::Admin::ListForm.new

    expect(form).to be_empty

    form.set_name 'Beers'

    form.add_beer 'Bear Republic Racer 5'
    form.add_beer 'Indeed Day Tripper'
    form.add_beer 'Deschutes Fresh Squeezed'

    form.submit

    expect(page).to have_css 'div.alert-success', text: 'List created'
    expect(form.beers.size).to eq 3

    beers = establishment.beers.map &:name
    expect(beers).to match_array [
      'Bear Republic Racer 5',
      'Indeed Day Tripper',
      'Deschutes Fresh Squeezed'
    ]

    form.remove_beer 'Bear Republic Racer 5'
    expect(form.beer_named('Bear Republic Racer 5')).to be_marked_for_removal

    form.submit
    expect(page).to have_css "div.alert-success", text: "List updated"
    expect(form.beers.size).to eq 2
  end

  scenario "an establishment's beer list can have prices and descriptions", :js, :admin do
    establishment = create :establishment, account: user.account
    login user

    click_link establishment.name
    click_link 'Add List'

    form = PageObjects::Admin::ListForm.new

    expect(form).to be_empty

    form.set_name 'Beers'

    form.add_beer('Bear Republic Racer 5', {
      price: '5.5',
      description: 'A crowd favorite'
    })
    form.add_beer('Indeed Day Tripper', {
      price: '5',
      description: 'The gold standard'
    })
    form.add_beer('Deschutes Fresh Squeezed', {
      price: '6',
      description: 'The biggest IPA this side of the Mississippi'
    })

    form.submit
    expect(page).to have_css "div.alert-success", text: "List created"
    expect(form.beers.size).to eq 3

    beers = establishment.beers.map { |b| [b.name, b.price_in_cents, b.description] }
    expect(beers).to eq([
      ['Bear Republic Racer 5', 550, 'A crowd favorite'],
      ['Indeed Day Tripper', 500, 'The gold standard'],
      ['Deschutes Fresh Squeezed', 600, 'The biggest IPA this side of the Mississippi']
    ])

    form.remove_beer 'Bear Republic Racer 5'
    expect(form.beer_named('Bear Republic Racer 5')).to be_marked_for_removal

    form.submit
    expect(page).to have_css "div.alert-success", text: "List updated"
    expect(all('[data-test="beer-input"]').size).to eq 2
  end

  scenario 'beers can be removed and unremoved from the beer list', :js, :admin do
    establishment = create :establishment, account: user.account
    login user

    click_link establishment.name
    click_link 'Add List'

    form = PageObjects::Admin::ListForm.new

    form.add_beer 'Bear Republic Racer 5'
    form.add_beer 'Indeed Day Tripper'

    form.submit
    expect(page).to have_css "div.alert-success", text: "List created"
    expect(form.beers.size).to eq 2

    form.remove_beer 'Bear Republic Racer 5'
    form.remove_beer 'Indeed Day Tripper'

    racer_5 = form.beer_named('Bear Republic Racer 5')
    day_tripper = form.beer_named('Indeed Day Tripper')

    expect(racer_5).to be_marked_for_removal
    expect(day_tripper).to be_marked_for_removal

    form.keep_beer 'Indeed Day Tripper'

    expect(day_tripper).to_not be_marked_for_removal

    form.submit
    expect(page).to have_css "div.alert-success", text: "List updated"
    expect(form.beers.size).to eq 1

    expect(form).to have_beer_named 'Indeed Day Tripper'
  end

  scenario 'unsaved beers can be deleted from the UI', :js, :admin do
    establishment = create :establishment, account: user.account
    login user

    click_link establishment.name

    click_link 'Add List'
    form = PageObjects::Admin::ListForm.new
    form.add_beer_button.click

    expect(form.beers.size).to eq 1
    form.beers.first.remove
    expect(form.beers.size).to eq 0
  end

  scenario "beers added to an establishment's list show up in Beermapper", :admin, :js do
    establishment = create :establishment, name: "Lebowski", account: user.account
    login user

    click_link establishment.name
    click_link 'Add List'

    form = PageObjects::Admin::ListForm.new
    form.set_name 'Beers'

    form.add_beer 'Deschutes Pinedrops'
    form.add_beer 'Deschutes Mirror Pond'
    form.add_beer 'Deschutes Big Rig'
    form.add_beer 'Indeed Stir Crazy'
    form.add_beer 'Surly Stout'
    form.add_beer 'Budweiser'

    form.submit
    expect(page).to have_css "div.alert-success", text: "List created"
    expect(form.beers.size).to eq 6

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

  scenario "an establishment's beers from multiple lists show up in Beermapper", :admin, :js do
    establishment = create :establishment, name: "Lebowski", account: user.account
    login user

    click_link establishment.name
    click_link 'Add List'

    taps_form = PageObjects::Admin::ListForm.new
    taps_form.set_name 'Taps'

    taps_form.add_beer 'Deschutes Pinedrops'
    taps_form.add_beer 'Deschutes Mirror Pond'
    taps_form.add_beer 'Deschutes Big Rig'
    taps_form.add_beer 'Indeed Stir Crazy'
    taps_form.add_beer 'Surly Stout'
    taps_form.add_beer 'Budweiser'

    taps_form.submit
    expect(page).to have_css "div.alert-success", text: "List created"
    expect(taps_form.beers.size).to eq 6

    taps_form.cancel
    click_link 'Add List'

    bottles_form = PageObjects::Admin::ListForm.new
    bottles_form.set_name 'Bottles'

    bottles_form.add_beer 'Summit EPA'
    bottles_form.add_beer 'Deschutes Fresh Squeezed'
    bottles_form.add_beer 'Indeed Double Day Tripper'
    bottles_form.add_beer 'Fulton War & Peace'

    bottles_form.submit
    expect(page).to have_css "div.alert-success", text: "List created"
    expect(bottles_form.beers.size).to eq 4

    visit 'http://test.beermapper.ember'
    fill_in 'search-field', with: 'Deschutes'
    click_button 'Search'

    find('div[title="Lebowski"]').trigger('click')
    within('.map-marker') do
      expect(page).to have_link 'Lebowski'
      expect(page).to have_css 'li', text: 'Deschutes Pinedrops'
      expect(page).to have_css 'li', text: 'Deschutes Mirror Pond'
      expect(page).to have_css 'li', text: 'Deschutes Big Rig'
      expect(page).to have_css 'li', text: 'Deschutes Fresh Squeezed'
    end

    click_link 'Lebowski'
    expect(page).to have_css 'li', text: 'Deschutes Pinedrops'
    expect(page).to have_css 'li', text: 'Deschutes Mirror Pond'
    expect(page).to have_css 'li', text: 'Deschutes Big Rig'
    expect(page).to have_css 'li', text: 'Deschutes Fresh Squeezed'
    expect(page).to have_css 'li', text: 'Indeed Stir Crazy'
    expect(page).to have_css 'li', text: 'Indeed Double Day Tripper'
    expect(page).to have_css 'li', text: 'Surly Stout'
    expect(page).to have_css 'li', text: 'Budweiser'
    expect(page).to have_css 'li', text: 'Fulton War & Peace'
    expect(page).to have_css 'li', text: 'Summit EPA'
  end

  scenario "beers added to an establishment's list show up on the establishment's website", :admin, :js do
    establishment = create :establishment, name: "The Lanes", account: user.account

    Beermapper::Application.load_tasks
    Rake::Task['generate_third_party_site'].invoke

    login user

    click_link establishment.name
    click_link 'Add List'

    form = PageObjects::Admin::ListForm.new
    form.set_name 'Beers'
    
    form.add_beer 'Deschutes Pinedrops'
    form.add_beer 'Deschutes Mirror Pond'
    form.add_beer 'Deschutes Big Rig'
    form.add_beer 'Indeed Stir Crazy'
    form.add_beer 'Surly Stout'
    form.add_beer 'Budweiser'

    form.submit
    expect(page).to have_css "div.alert-success", text: "List created"
    expect(form.beers.size).to eq 6


    visit 'http://test.my-bar.dev'
    expect(page).to have_content 'Deschutes Pinedrops'
    expect(page).to have_content 'Deschutes Mirror Pond'
    expect(page).to have_content 'Deschutes Big Rig'
    expect(page).to have_content 'Indeed Stir Crazy'
    expect(page).to have_content 'Surly Stout'
    expect(page).to have_content 'Budweiser'
  end
end
