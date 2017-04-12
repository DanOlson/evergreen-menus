require 'spec_helper'

feature 'establishment management' do
  let(:user) { create :user, :manager }

  scenario 'creating an establishment' do
    login user
    find('[data-test="add-establishment"]').click

    form = PageObjects::Admin::EstablishmentForm.new

    form.set_name 'The Lanes'
    form.set_url 'http://thelanes.com/beer-menu'
    form.set_street '123 Freemont Ave'
    form.set_city 'Encino'
    form.set_state 'California'
    form.set_postal_code '91316'

    form.submit

    expect(page).to have_current_path "/accounts/#{user.account_id}"
    expect(page).to have_css "div.alert-success", text: "Establishment created"
    expect(page).to have_selector "[data-test='establishment']", text: "The Lanes"
  end

  scenario 'editing an establishment' do
    establishment = create :establishment, account: user.account
    login user

    click_link establishment.name

    form = PageObjects::Admin::EstablishmentForm.new

    form.set_name 'Sobchak Security'
    form.set_url 'http://sobsec.com/beer-menu'
    form.set_street '15 EmPeeAich Ave'
    form.set_city 'Encino'
    form.set_state 'California'
    form.set_postal_code '91316'

    form.submit

    expect(page).to have_current_path "/accounts/#{user.account_id}/establishments/#{establishment.id}/edit"
    expect(page).to have_css "div.alert-success", text: "Establishment updated"
    expect(page).to have_selector "input[value='Sobchak Security']"
  end

  scenario "editing an establishment's beer list", :js, :admin do
    establishment = create :establishment, account: user.account
    login user

    click_link establishment.name
    establishment_form = PageObjects::Admin::EstablishmentForm.new
    establishment_form.add_list

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
    establishment_form = PageObjects::Admin::EstablishmentForm.new
    establishment_form.add_list

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
    establishment_form = PageObjects::Admin::EstablishmentForm.new
    establishment_form.add_list

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

    establishment_form = PageObjects::Admin::EstablishmentForm.new
    establishment_form.add_list

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
    establishment_form = PageObjects::Admin::EstablishmentForm.new
    establishment_form.add_list

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
    establishment_form = PageObjects::Admin::EstablishmentForm.new
    establishment_form.add_list

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

    bottles_form.cancel
    establishment_form = PageObjects::Admin::EstablishmentForm.new
    expect(establishment_form.lists.size).to eq 2

    expect(establishment_form).to have_list_named 'Taps'
    expect(establishment_form).to have_list_named 'Bottles'

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

    login user

    click_link establishment.name
    establishment_form = PageObjects::Admin::EstablishmentForm.new
    establishment_form.add_list

    form = PageObjects::Admin::ListForm.new
    form.set_name 'Beers'
    
    form.add_beer 'Deschutes Pinedrops', price: '6', description: 'IPA'
    form.add_beer 'Deschutes Mirror Pond', price: '6', description: 'APA'
    form.add_beer 'Deschutes Big Rig', price: '6', description: '???'
    form.add_beer 'Indeed Stir Crazy', price: '7', description: 'Winter Seasonal'
    form.add_beer 'Surly Stout', price: '6.5', description: 'Stout'
    form.add_beer 'Budweiser', price: '4.5', description: 'Meh'

    form.submit
    expect(page).to have_css "div.alert-success", text: "List created"
    expect(form.beers.size).to eq 6
    list_url = page.current_url

    form.cancel

    establishment_form = PageObjects::Admin::EstablishmentForm.new
    list_html = establishment_form.get_snippet_for 'Beers'

    ThirdPartySiteGenerator.call({
      establishment: establishment,
      list_snippets: [list_html]
    })

    menu = PageObjects::ThirdPartySite::Menu.new
    menu.load

    list = menu.lists.first
    expect(list).to have_item_named 'Deschutes Pinedrops'
    pinedrops = list.item_named 'Deschutes Pinedrops'
    expect(pinedrops.price.text).to eq '$6'
    expect(pinedrops.description.text).to eq 'IPA'

    expect(list).to have_item_named 'Deschutes Mirror Pond'
    mirror_pond = list.item_named 'Deschutes Mirror Pond'
    expect(mirror_pond.price.text).to eq '$6'
    expect(mirror_pond.description.text).to eq 'APA'

    expect(list).to have_item_named 'Deschutes Big Rig'
    big_rig = list.item_named 'Deschutes Big Rig'
    expect(big_rig.price.text).to eq '$6'
    expect(big_rig.description.text).to eq '???'

    expect(list).to have_item_named 'Indeed Stir Crazy'
    stir_crazy = list.item_named 'Indeed Stir Crazy'
    expect(stir_crazy.price.text).to eq '$7'
    expect(stir_crazy.description.text).to eq 'Winter Seasonal'

    expect(list).to have_item_named 'Surly Stout'
    surly_stout = list.item_named 'Surly Stout'
    expect(surly_stout.price.text).to eq '$6.50'
    expect(surly_stout.description.text).to eq 'Stout'

    expect(list).to have_item_named 'Budweiser'
    bud = list.item_named 'Budweiser'
    expect(bud.price.text).to eq '$4.50'
    expect(bud.description.text).to eq 'Meh'

    visit list_url
    list_form = PageObjects::Admin::ListForm.new
    list_form.hide_prices
    list_form.submit

    menu.load
    expect(menu.list_named('Beers')).to_not have_prices
    expect(menu.list_named('Beers')).to have_descriptions

    visit list_url
    list_form = PageObjects::Admin::ListForm.new
    list_form.hide_descriptions
    list_form.submit

    menu.load
    expect(menu.list_named('Beers')).to_not have_prices
    expect(menu.list_named('Beers')).to_not have_descriptions

    visit list_url
    list_form = PageObjects::Admin::ListForm.new
    list_form.show_prices
    list_form.show_descriptions
    list_form.submit

    menu.load
    expect(menu.list_named('Beers')).to have_prices
    expect(menu.list_named('Beers')).to have_descriptions
  end

  scenario 'list html snippets are visible by managers, but not staff', :admin, :js do
    establishment = create :establishment, name: "The Lanes", account: user.account
    staff_member = create :user, account: user.account

    login user

    click_link establishment.name
    establishment_form = PageObjects::Admin::EstablishmentForm.new
    establishment_form.add_list

    form = PageObjects::Admin::ListForm.new
    form.set_name 'Taps'

    form.add_beer 'Deschutes Pinedrops'
    form.add_beer 'Deschutes Mirror Pond'
    form.add_beer 'Deschutes Big Rig'

    form.submit
    form.cancel

    establishment_form = PageObjects::Admin::EstablishmentForm.new
    list = establishment_form.list_named 'Taps'

    expect(list).to have_toggle_snippet_button
    list.show_snippet
    expect(list).to have_html_snippet

    logout

    login staff_member

    click_link establishment.name
    establishment_form = PageObjects::Admin::EstablishmentForm.new
    list = establishment_form.list_named 'Taps'
    expect(list).to_not have_toggle_snippet_button
    expect(list).to_not have_html_snippet
  end

  scenario 'lists can be deleted', :admin, :js do
    establishment = create :establishment, name: "The Lanes", account: user.account
    list = establishment.lists.create!(name: 'Weekly Specials')

    login user

    list_form = PageObjects::Admin::ListForm.new
    list_form.load({
      account_id: establishment.account_id,
      establishment_id: establishment.id,
      list_id: list.id
    })

    expect(list_form).to be_displayed
    list_form.delete

    expect(page.current_path).to eq "/accounts/#{establishment.account_id}/establishments/#{establishment.id}/edit"

    expect(page).to have_css "div.alert-success", text: "List deleted"
  end
end
