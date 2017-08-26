require 'spec_helper'

feature 'digital display menu management' do
  let(:account) { create :account }
  let(:establishment) { create :establishment, account: account }

  before do
    taps_list = establishment.lists.create!({
      name: 'Taps'
    })
    taps_list.beers.create!(
      name: 'Fulton Sweet Child of Vine',
      price: '5'
    )
    taps_list.beers.create!(
      name: 'Nitro Milk Stout',
      price: '6.50'
    )
    bottles_list = establishment.lists.create!({
      name: 'Bottles'
    })
    bottles_list.beers.create!(
      name: 'Arrogant Bastard',
      price: '7.50'
    )
  end

  def run_test(user)
    login user
    click_link establishment.name

    establishment_form = PageObjects::Admin::EstablishmentForm.new
    establishment_form.add_digital_display_menu

    display_form = PageObjects::Admin::DigitalDisplayMenuForm.new
    # Query the form
    expect(display_form).to be_displayed
    expect(display_form).to have_available_list 'Taps'
    expect(display_form).to have_available_list 'Bottles'
    expect(display_form.orientation).to eq :horizontal

    # Manipulate the form
    display_form.name = 'Test Display'
    display_form.select_list 'Taps'
    display_form.select_list 'Bottles'

    # Query form again
    expect(display_form).to have_selected_list 'Taps'
    expect(display_form).to have_selected_list 'Bottles'
    expect(display_form.selected_list_named('Taps')).to have_price_shown
    expect(display_form.selected_list_named('Bottles')).to have_price_shown

    # Query preview
    expect(display_form.preview).to have_list 'Taps'
    expect(display_form.preview).to have_list 'Bottles'
    expect(display_form.preview).to be_oriented_horizontally
    preview_taps_list = display_form.preview.list_named('Taps')
    preview_bottles_list = display_form.preview.list_named('Bottles')
    expect(preview_taps_list).to have_beer 'Fulton Sweet Child of Vine'
    expect(preview_taps_list).to have_beer 'Nitro Milk Stout'
    expect(preview_bottles_list).to have_beer 'Arrogant Bastard'
    expect(preview_taps_list.beer_named('Fulton Sweet Child of Vine').price).to eq '$5.00'
    expect(preview_taps_list.beer_named('Nitro Milk Stout').price).to eq '$6.50'
    expect(preview_bottles_list.beer_named('Arrogant Bastard').price).to eq '$7.50'

    # Submit
    display_form.submit

    expect(page).to have_css '[data-test="flash-success"]', text: "Digital display menu created"

    # Verify form submission was persisted
    expect(display_form.name).to eq 'Test Display'
    expect(display_form).to have_selected_list 'Taps'
    expect(display_form).to have_selected_list 'Bottles'

    # Manipulate them form some more
    display_form.name = 'HD Display'
    display_form.remove_list 'Bottles'
    display_form.hide_prices(list: 'Taps')
    display_form.set_orientation :vertical

    # Query the form
    expect(display_form).to have_selected_list 'Taps'
    expect(display_form).to have_available_list 'Bottles'
    expect(display_form).to_not have_selected_list 'Bottles'
    expect(display_form).to_not have_available_list 'Taps'
    expect(display_form.selected_list_named('Taps')).to_not have_price_shown
    expect(display_form.orientation).to eq :vertical

    # Query the preview
    expect(display_form.preview).to have_list 'Taps'
    expect(display_form.preview).to_not have_list 'Bottles'
    expect(display_form.preview).to be_oriented_vertically
    preview_taps_list = display_form.preview.list_named('Taps')
    expect(preview_taps_list.beer_named('Fulton Sweet Child of Vine')).to_not have_price
    expect(preview_taps_list.beer_named('Nitro Milk Stout')).to_not have_price

    # Submit new changes
    display_form.submit

    expect(page).to have_css '[data-test="flash-success"]', text: "Digital display menu updated"

    # Verify form submission was persisted
    expect(display_form.name).to eq 'HD Display'
    expect(display_form).to have_selected_list 'Taps'
    expect(display_form).to have_available_list 'Bottles'
    expect(display_form).to_not have_selected_list 'Bottles'
    expect(display_form).to_not have_available_list 'Taps'
    expect(display_form.selected_list_named('Taps')).to_not have_price_shown
    expect(display_form.orientation).to eq :vertical

    # Verify preview
    expect(display_form.preview).to have_list 'Taps'
    expect(display_form.preview).to_not have_list 'Bottles'
    expect(display_form.preview).to be_oriented_vertically
    preview_taps_list = display_form.preview.list_named('Taps')
    expect(preview_taps_list.beer_named('Fulton Sweet Child of Vine')).to_not have_price
    expect(preview_taps_list.beer_named('Nitro Milk Stout')).to_not have_price

    # Validate digital display menu (show)
    display_form.visit_digital_display_menu
    display_url = current_url
    digital_display = PageObjects::Admin::DigitalDisplayMenu.new
    expect(digital_display).to be_displayed
    expect(digital_display).to have_list_named('Taps')
    expect(digital_display).to be_oriented_vertically

    taps_list = digital_display.list_named('Taps')
    expect(taps_list).to have_beer_named 'Fulton Sweet Child of Vine'
    expect(taps_list).to have_beer_named 'Nitro Milk Stout'
    expect(taps_list.beer_named('Fulton Sweet Child of Vine')).to_not have_price
    expect(taps_list.beer_named('Nitro Milk Stout')).to_not have_price
  end

  scenario 'manager can manage a digital display menu for their establishments', :js, :admin do
    manager = create :user, :manager, account: account

    run_test manager
  end

  scenario 'staff with establishment access can manage a digital display menu', :js, :admin do
    staff = create :user, account: account
    staff.establishments << establishment

    run_test staff
  end

  scenario 'staff without access cannot access digital display menu', :js, :admin do
    staff = create :user, account: account
    login staff
    visit "/accounts/#{account.id}/establishments/#{establishment.id}/digital_displays/new"

    display_form = PageObjects::Admin::DigitalDisplayMenuForm.new
    expect(display_form).to_not be_displayed
    expect(page).to have_css '[data-test="flash-alert"]', text: 'You are not authorized to access this page'
  end
end