require 'spec_helper'

feature 'establishment management' do
  let(:user) { create :user, :manager }

  scenario 'creating an establishment' do
    login user
    find('[data-test="add-establishment"]').click

    form = PageObjects::Admin::EstablishmentForm.new

    form.set_name 'The Lanes'
    form.set_url 'http://thelanes.com/beer-menu'
    form.submit

    expect(form).to be_displayed
    expect(page).to have_css "div.alert-success", text: "Establishment created"
  end

  scenario 'editing an establishment' do
    establishment = create :establishment, account: user.account
    login user

    click_link establishment.name

    form = PageObjects::Admin::EstablishmentForm.new

    form.set_name 'Sobchak Security'
    form.set_url 'http://sobsec.com/beer-menu'
    form.submit

    expect(form).to be_displayed
    expect(page).to have_css "div.alert-success", text: "Establishment updated"
    expect(page).to have_selector "input[value='Sobchak Security']"
  end

  scenario 'deleting an establishment', :js, :admin do
    establishment_1 = create :establishment, account: user.account
    establishment_2 = create :establishment, account: user.account
    staff_member = create :user, account: user.account

    login user

    form = PageObjects::Admin::EstablishmentForm.new
    form.load({
      account_id: establishment_1.account_id,
      establishment_id: establishment_1.id
    })

    form.delete

    expect(page).to have_current_path "/accounts/#{user.account_id}"
    expect(page).to have_css 'div.alert-success', text: 'Establishment deleted'

    logout
    login staff_member

    form = PageObjects::Admin::EstablishmentForm.new
    form.load({
      account_id: establishment_2.account_id,
      establishment_id: establishment_2.id
    })
    expect(form).to_not have_delete_button
  end

  scenario "editing a list", :js, :admin do
    establishment = create :establishment, account: user.account
    login user

    click_link establishment.name
    establishment_form = PageObjects::Admin::EstablishmentForm.new

    expect(establishment_form.add_web_menu_button[:class]).to include('disabled')
    expect(establishment_form.add_menu_button[:class]).to include('disabled')
    expect(establishment_form.add_digital_display_menu_button[:class]).to include('disabled')

    establishment_form.add_list

    form = PageObjects::Admin::ListForm.new

    expect(form).to be_empty
    expect(form.list_type).to eq 'Food'

    form.set_name 'Beers'

    form.add_beer 'Bear Republic Racer 5'
    form.add_beer 'Indeed Day Tripper'
    form.add_beer 'Deschutes Fresh Squeezed'

    form.submit

    expect(page).to have_css 'div.alert-success', text: 'List created'
    expect(establishment_form).to be_displayed
    establishment_form.click_list_named('Beers')
    expect(form).to be_displayed
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
    expect(establishment_form).to be_displayed
    establishment_form.click_list_named('Beers')
    expect(form).to be_displayed
    expect(form.beers.size).to eq 2
  end

  scenario "a list can have prices and descriptions", :js, :admin do
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
    establishment_form.click_list_named 'Beers'
    expect(form.beers.size).to eq 3

    beers = establishment.beers.order(:created_at).map { |b| [b.name, b.price_in_cents, b.description] }
    expect(beers).to eq([
      ['Bear Republic Racer 5', 550, 'A crowd favorite'],
      ['Indeed Day Tripper', 500, 'The gold standard'],
      ['Deschutes Fresh Squeezed', 600, 'The biggest IPA this side of the Mississippi']
    ])

    form.remove_beer 'Bear Republic Racer 5'
    expect(form.beer_named('Bear Republic Racer 5')).to be_marked_for_removal

    form.submit
    expect(page).to have_css "div.alert-success", text: "List updated"
    establishment_form.click_list_named 'Beers'
    expect(all('[data-test="beer-input"]').size).to eq 2
  end

  scenario 'items can be removed and unremoved from the list', :js, :admin do
    establishment = create :establishment, account: user.account
    login user

    click_link establishment.name
    establishment_form = PageObjects::Admin::EstablishmentForm.new
    establishment_form.add_list

    form = PageObjects::Admin::ListForm.new
    form.set_name 'Beers'

    form.add_beer 'Bear Republic Racer 5'
    form.add_beer 'Indeed Day Tripper'

    form.submit
    expect(page).to have_css "div.alert-success", text: "List created"
    expect(establishment_form).to be_displayed
    establishment_form.click_list_named('Beers')
    expect(form).to be_displayed
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
    expect(establishment_form).to be_displayed
    establishment_form.click_list_named('Beers')
    expect(form).to be_displayed

    expect(form).to have_beer_named 'Indeed Day Tripper'
  end

  scenario 'unsaved items can be deleted from the UI', :js, :admin do
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

  scenario "items added to a list show up on the establishment's website", :admin, :js do
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
    establishment_form.click_list_named 'Beers'
    expect(form.beers.size).to eq 6
    form.cancel

    establishment_form.add_web_menu
    web_menu_form = PageObjects::Admin::WebMenuForm.new
    web_menu_form.name = 'Beer Menu'
    web_menu_form.select_list 'Beers'
    web_menu_form.submit

    web_menu_url = page.current_url
    embed_code = web_menu_form.get_embed_code

    ThirdPartySiteGenerator.call({
      establishment: establishment,
      list_snippets: [embed_code]
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

    visit web_menu_url
    web_menu_form.hide_prices list: 'Beers'
    web_menu_form.submit

    menu.load
    expect(menu.list_named('Beers')).to_not have_prices
    expect(menu.list_named('Beers')).to have_descriptions

    visit web_menu_url
    web_menu_form.hide_descriptions list: 'Beers'
    web_menu_form.submit

    menu.load
    expect(menu.list_named('Beers')).to_not have_prices
    expect(menu.list_named('Beers')).to_not have_descriptions

    visit web_menu_url
    web_menu_form.show_prices list: 'Beers'
    web_menu_form.show_descriptions list: 'Beers'
    web_menu_form.submit

    menu.load
    expect(menu.list_named('Beers')).to have_prices
    expect(menu.list_named('Beers')).to have_descriptions
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

  scenario 'labels can be applied to list items', :admin, :js do
    establishment = create :establishment, name: "Wally's", account: user.account
    login user

    click_link "Wally's"
    establishment_form = PageObjects::Admin::EstablishmentForm.new
    establishment_form.add_list

    form = PageObjects::Admin::ListForm.new

    expect(form).to be_empty

    form.set_name 'Apps'
    form.list_type = 'Food'

    form.add_beer('Tuna Tartare', {
      price: '15',
      description: 'Raw tuna on hard bread',
      labels: ['Vegetarian']
    })
    form.add_beer('Buffalo Wings', {
      price: '10',
      description: 'Two and a half chickens worth of delicious bone-in wings',
      labels: ['Spicy', 'Gluten Free']
    })

    form.submit
    expect(page).to have_css "div.alert-success", text: "List created"
    establishment_form.click_list_named('Apps')

    tuna = form.beer_named('Tuna Tartare')
    expect(tuna).to have_labels 'Vegetarian'

    wings = form.beer_named('Buffalo Wings')
    expect(wings).to have_labels 'Spicy', 'Gluten Free'

    wings.labels = []

    form.submit
    establishment_form.click_list_named('Apps')

    wings = form.beer_named('Buffalo Wings')
    expect(wings).to have_no_labels
  end

  scenario 'contextual help', :admin, :js do
    login user
    find('[data-test="add-establishment"]').click

    form = PageObjects::Admin::EstablishmentForm.new
    expect(form.lists_panel).to have_help_text
    expect(form.menus_panel).to have_help_text

    form.set_name 'The Lanes'
    form.set_url 'http://thelanes.com/beer-menu'
    form.submit

    expect(form.lists_panel).to have_help_text
    expect(form.menus_panel).to have_help_text

    form.add_list

    list_form = PageObjects::Admin::ListForm.new
    list_form.set_name 'Beers'

    list_form.add_beer 'Deschutes Pinedrops', price: '6', description: 'IPA'
    list_form.add_beer 'Deschutes Mirror Pond', price: '6', description: 'APA'
    list_form.add_beer 'Indeed Stir Crazy', price: '7', description: 'Winter Seasonal'
    list_form.add_beer 'Surly Stout', price: '6.5', description: 'Stout'

    list_form.submit

    expect(form).to be_displayed
    expect(form.lists_panel).to have_no_help_text
    expect(form.menus_panel).to have_help_text

    form.add_menu

    menu_form = PageObjects::Admin::MenuForm.new
    menu_form.name = 'Beer Menu'
    menu_form.select_list 'Beers'
    menu_form.submit
    menu_form.cancel

    expect(form).to be_displayed
    expect(form.lists_panel).to have_no_help_text
    expect(form.menus_panel).to have_no_help_text

    form.add_digital_display_menu

    display_form = PageObjects::Admin::DigitalDisplayMenuForm.new
    display_form.name = 'Test Display'
    display_form.select_list 'Beers'
    display_form.submit
    display_form.cancel

    expect(form).to be_displayed
    expect(form.lists_panel).to have_no_help_text
    expect(form.menus_panel).to have_no_help_text

    form.toggle_lists_help
    expect(form.lists_panel).to have_help_text
    form.toggle_lists_help
    expect(form.lists_panel).to have_no_help_text

    form.toggle_menus_help
    expect(form.menus_panel).to have_help_text
    form.toggle_menus_help
    expect(form.menus_panel).to have_no_help_text
  end

  scenario 'Google Menu appears in menu list when it exists' do
    establishment = create :establishment, account: user.account
    create :google_menu, name: 'My Google Menu', establishment: establishment
    login user

    establishment_form = PageObjects::Admin::EstablishmentForm.new
    establishment_form.load({
      account_id: establishment.account_id,
      establishment_id: establishment.id
    })
    expect(establishment_form).to have_google_menu
  end
end
