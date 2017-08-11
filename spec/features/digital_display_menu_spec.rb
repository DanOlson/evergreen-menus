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
    expect(display_form).to be_displayed
    expect(display_form).to have_available_list 'Taps'
    expect(display_form).to have_available_list 'Bottles'

    display_form.name = 'Test Display'
    display_form.select_list 'Taps'
    display_form.select_list 'Bottles'

    expect(display_form).to have_selected_list 'Taps'
    expect(display_form).to have_selected_list 'Bottles'

    expect(display_form.preview).to have_list 'Taps'
    expect(display_form.preview).to have_list 'Bottles'

    expect(display_form.preview.list_named('Taps')).to have_beer 'Fulton Sweet Child of Vine'
    expect(display_form.preview.list_named('Taps')).to have_beer 'Nitro Milk Stout'
    expect(display_form.preview.list_named('Bottles')).to have_beer 'Arrogant Bastard'

    display_form.submit

    expect(page).to have_css '[data-test="flash-success"]', text: "Digital display menu created"

    expect(display_form.name).to eq 'Test Display'
    expect(display_form).to have_selected_list 'Taps'
    expect(display_form).to have_selected_list 'Bottles'

    display_form.name = 'HD Display'
    display_form.remove_list 'Bottles'

    expect(display_form).to have_selected_list 'Taps'
    expect(display_form).to have_available_list 'Bottles'
    expect(display_form).to_not have_selected_list 'Bottles'
    expect(display_form).to_not have_available_list 'Taps'

    expect(display_form.preview).to have_list 'Taps'
    expect(display_form.preview).to_not have_list 'Bottles'

    display_form.submit

    expect(page).to have_css '[data-test="flash-success"]', text: "Digital display menu updated"

    expect(display_form.name).to eq 'HD Display'
    expect(display_form).to have_selected_list 'Taps'
    expect(display_form).to have_available_list 'Bottles'
    expect(display_form).to_not have_selected_list 'Bottles'
    expect(display_form).to_not have_available_list 'Taps'

    expect(display_form.preview).to have_list 'Taps'
    expect(display_form.preview).to_not have_list 'Bottles'
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
end
