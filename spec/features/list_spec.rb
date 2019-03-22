require 'spec_helper'

describe 'list management' do
  let(:account) { create :account, :with_subscription }
  let(:user) { create :user, :account_admin, account: account }

  scenario 'adding a list', :js, :admin do
    establishment = create :establishment, account: account
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
    form.description = 'All our beer is locally sourced and grass-fed.'
    form.notes = 'Our tap lines are cleaned at least twice per year'

    form.add_beer 'Bear Republic Racer 5'
    form.add_beer 'Indeed Day Tripper'
    form.add_beer 'Deschutes Fresh Squeezed'

    form.submit

    expect(page).to have_css '[data-test="flash-success"]', text: 'List created'
    expect(establishment_form).to be_displayed
    establishment_form.click_list_named('Beers')
    expect(form).to be_displayed
    expect(form.beers.size).to eq 3
    expect(form.description).to eq 'All our beer is locally sourced and grass-fed.'
    expect(form.notes).to eq 'Our tap lines are cleaned at least twice per year'

    beers = establishment.beers.map &:name
    expect(beers).to match_array [
      'Bear Republic Racer 5',
      'Indeed Day Tripper',
      'Deschutes Fresh Squeezed'
    ]

    form.remove_beer 'Bear Republic Racer 5'
    expect(form.beer_named('Bear Republic Racer 5')).to be_marked_for_removal

    form.submit
    expect(page).to have_css '[data-test="flash-success"]', text: "List updated"
    expect(establishment_form).to be_displayed
    establishment_form.click_list_named('Beers')
    expect(form).to be_displayed
    expect(form.beers.size).to eq 2
  end

  scenario 'list items can have prices and descriptions', :js, :admin do
    establishment = create :establishment, account: account
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
    expect(page).to have_css '[data-test="flash-success"]', text: "List created"
    establishment_form.click_list_named 'Beers'
    expect(form.beers.size).to eq 3

    beers = establishment.beers.order(:created_at).map { |b| [b.name, b.price, b.description] }
    expect(beers).to eq([
      ['Bear Republic Racer 5', 5.5, 'A crowd favorite'],
      ['Indeed Day Tripper', 5, 'The gold standard'],
      ['Deschutes Fresh Squeezed', 6, 'The biggest IPA this side of the Mississippi']
    ])

    form.remove_beer 'Bear Republic Racer 5'
    expect(form.beer_named('Bear Republic Racer 5')).to be_marked_for_removal

    form.submit
    expect(page).to have_css '[data-test="flash-success"]', text: "List updated"
    establishment_form.click_list_named 'Beers'
    expect(all('[data-test="beer-input"]').size).to eq 2
  end

  scenario 'list items can have images', :js, :admin do
    establishment = create :establishment, account: account
    login user

    click_link establishment.name
    establishment_form = PageObjects::Admin::EstablishmentForm.new
    establishment_form.add_list

    form = PageObjects::Admin::ListForm.new

    expect(form).to be_empty

    form.set_name 'Beers'

    form.add_beer('Bear Republic Racer 5', {
      price: '5.5',
      description: 'A crowd favorite',
      image: Rails.root.join('spec/fixtures/files/bear-republic-logo.png')
    })
    form.add_beer('Indeed Day Tripper', {
      price: '5',
      description: 'The gold standard',
      image: Rails.root.join('spec/fixtures/files/indeed-logo.png')
    })
    form.add_beer('Deschutes Fresh Squeezed', {
      price: '6',
      description: 'The biggest IPA this side of the Mississippi',
      image: Rails.root.join('spec/fixtures/files/deschutes-logo.png')
    })

    form.submit
    expect(page).to have_css '[data-test="flash-success"]', text: 'List created'
    establishment_form.click_list_named 'Beers'
    expect(form.beers.size).to eq 3

    racer_five = form.beer_named 'Bear Republic Racer 5'
    expect(racer_five.image_label_text).to eq 'bear-republic-logo.png'

    day_tripper = form.beer_named 'Indeed Day Tripper'
    expect(day_tripper.image_label_text).to eq 'indeed-logo.png'

    fresh_squeezed = form.beer_named 'Deschutes Fresh Squeezed'
    expect(fresh_squeezed.image_label_text).to eq 'deschutes-logo.png'

    fresh_squeezed.image = Rails.root.join('spec/fixtures/files/dinner-menu.pdf')
    expect(fresh_squeezed).to_not have_valid_image

    form.submit
    expect(form).to be_displayed
    expect(fresh_squeezed).to_not have_valid_image

    fresh_squeezed.image = Rails.root.join('spec/fixtures/files/deschutes-logo.png')
    expect(fresh_squeezed).to have_valid_image
    form.submit

    expect(page).to have_css '[data-test="flash-success"]', text: 'List updated'

    establishment.beers.each do |item|
      expect(item.image).to be_attached
    end
  end

  scenario 'items can be removed and unremoved from the list', :js, :admin do
    establishment = create :establishment, account: account
    login user

    click_link establishment.name
    establishment_form = PageObjects::Admin::EstablishmentForm.new
    establishment_form.add_list

    form = PageObjects::Admin::ListForm.new
    form.set_name 'Beers'

    form.add_beer 'Bear Republic Racer 5'
    form.add_beer 'Indeed Day Tripper'

    form.submit
    expect(page).to have_css '[data-test="flash-success"]', text: "List created"
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
    expect(page).to have_css '[data-test="flash-success"]', text: "List updated"
    expect(establishment_form).to be_displayed
    establishment_form.click_list_named('Beers')
    expect(form).to be_displayed

    expect(form).to have_beer_named 'Indeed Day Tripper'
  end

  scenario 'unsaved items can be deleted from the UI', :js, :admin do
    establishment = create :establishment, account: account
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
    establishment = create :establishment, name: "The Lanes", account: account

    login user

    click_link establishment.name
    establishment_form = PageObjects::Admin::EstablishmentForm.new
    establishment_form.add_list

    form = PageObjects::Admin::ListForm.new
    form.set_name 'Beers'
    form.description = 'We carry the best beers in town'

    form.add_beer 'Deschutes Pinedrops', price: '6', description: 'IPA'
    form.add_beer 'Deschutes Mirror Pond', price: '6', description: 'APA'
    form.add_beer 'Deschutes Big Rig', price: '6', description: '???'
    form.add_beer 'Indeed Stir Crazy', price: '7', description: 'Winter Seasonal'
    form.add_beer 'Surly Stout', price: '6.5', description: 'Stout'
    form.add_beer 'Budweiser', price: '4.5', description: 'Meh'

    form.submit
    expect(page).to have_css '[data-test="flash-success"]', text: "List created"
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
    expect(list.title).to eq 'Beers'
    expect(list.description).to eq 'We carry the best beers in town'
    expect(list).to have_item_named 'Deschutes Pinedrops'
    pinedrops = list.item_named 'Deschutes Pinedrops'
    expect(pinedrops.price.text).to eq '6'
    expect(pinedrops.description.text).to eq 'IPA'

    expect(list).to have_item_named 'Deschutes Mirror Pond'
    mirror_pond = list.item_named 'Deschutes Mirror Pond'
    expect(mirror_pond.price.text).to eq '6'
    expect(mirror_pond.description.text).to eq 'APA'

    expect(list).to have_item_named 'Deschutes Big Rig'
    big_rig = list.item_named 'Deschutes Big Rig'
    expect(big_rig.price.text).to eq '6'
    expect(big_rig.description.text).to eq '???'

    expect(list).to have_item_named 'Indeed Stir Crazy'
    stir_crazy = list.item_named 'Indeed Stir Crazy'
    expect(stir_crazy.price.text).to eq '7'
    expect(stir_crazy.description.text).to eq 'Winter Seasonal'

    expect(list).to have_item_named 'Surly Stout'
    surly_stout = list.item_named 'Surly Stout'
    expect(surly_stout.price.text).to eq '6.5'
    expect(surly_stout.description.text).to eq 'Stout'

    expect(list).to have_item_named 'Budweiser'
    bud = list.item_named 'Budweiser'
    expect(bud.price.text).to eq '4.5'
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
    establishment = create :establishment, name: "The Lanes", account: account
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

    expect(page).to have_css '[data-test="flash-success"]', text: "List deleted"
  end

  scenario 'labels can be applied to list items', :admin, :js do
    establishment = create :establishment, name: "Wally's", account: account
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
    expect(page).to have_css '[data-test="flash-success"]', text: 'List created'
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

  scenario 'list items can have multiple price options', :js, :admin do
    establishment = create :establishment, name: "Wally's", account: account
    login user

    click_link "Wally's"
    establishment_form = PageObjects::Admin::EstablishmentForm.new
    establishment_form.add_list

    form = PageObjects::Admin::ListForm.new

    form.set_name 'Red Wine'

    form.add_item('Carmenere', {
      price_options: [
        { price: '9', unit: 'Glass' },
        { price: '44', unit: 'Bottle' },
      ]
    })

    form.submit
    expect(page).to have_css '[data-test="flash-success"]', text: 'List created'

    establishment_form.click_list_named('Red Wine')

    carmenere = form.item_named('Carmenere')
    opt1 = carmenere.price_options[0]
    opt2 = carmenere.price_options[1]

    expect(opt1.price).to eq '9'
    expect(opt1.unit).to eq 'Glass'

    expect(opt2.price).to eq '44'
    expect(opt2.unit).to eq 'Bottle'

    opt2.unit = 'Glass'
    form.submit
    expect(page).to have_css '[data-test="flash-alert"]', text: 'Item price options may not have duplicate units'
    bottle_price = form.item_named('Carmenere').price_options.find { |o| o.price == '44' }
    bottle_price.unit = 'Bottle'
    form.submit
    expect(page).to have_css '[data-test="flash-success"]', text: 'List updated'

    establishment_form.click_list_named('Red Wine')
    expect(form).to be_displayed
    carmenere = form.item_named('Carmenere')
    expect(carmenere.price_options.size).to eq 2
    carmenere.remove_price_option('Bottle')
    expect(carmenere.price_options.size).to eq 1
    form.submit
    expect(page).to have_css '[data-test="flash-success"]', text: 'List updated'

    establishment_form.click_list_named('Red Wine')
    carmenere = form.item_named('Carmenere')
    expect(carmenere.price_options.size).to eq 1
    expect(carmenere.price_options.first.unit).to eq 'Glass'
  end
end
