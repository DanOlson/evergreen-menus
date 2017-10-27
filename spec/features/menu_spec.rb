require 'spec_helper'

feature 'menu management' do
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
    bottles_list = establishment.lists.create!({
      name: 'Bottles'
    })
    bottles_list.beers.create!(
      name: 'Arrogant Bastard',
      price: '7.50'
    )
    specials_list = establishment.lists.create!({
      name: 'Specials'
    })
    specials_list.beers.create!(
      name: 'Nitro Milk Stout'
    )
  end

  scenario 'manager can manage a menu for their account', :js, :admin do
    manager = create :user, :manager, account: account

    login manager

    click_link establishment.name

    establishment_form = PageObjects::Admin::EstablishmentForm.new
    establishment_form.add_menu

    menu_form = PageObjects::Admin::MenuForm.new
    expect(menu_form).to be_displayed
    expect(menu_form).to have_no_download_button
    expect(menu_form).to have_menu_preview
    expect(menu_form.menu_preview).to have_font('Helvetica')
    expect(menu_form).to have_font_size(10)

    expect(menu_form).to have_available_list('Taps')
    expect(menu_form).to have_available_list('Bottles')
    expect(menu_form).to have_available_list('Specials')

    expect(menu_form.available_list_named('Taps').badge_text).to eq '1 item'
    expect(menu_form.available_list_named('Bottles').badge_text).to eq '1 item'
    expect(menu_form.available_list_named('Specials').badge_text).to eq '1 item'

    menu_form.name = 'Taps - Mini Insert'
    menu_form.font = 'Courier'
    menu_form.font_size = 8
    menu_form.columns = 2
    menu_form.select_list('Taps')

    expect(menu_form).to have_selected_list('Taps')
    expect(menu_form).to have_available_list('Bottles')
    expect(menu_form).to have_available_list('Specials')

    expect(menu_form).to have_preview_content 'Taps - Mini Insert'
    expect(menu_form).to have_preview_content 'Fulton Sweet Child of Vine'
    expect(menu_form).to have_preview_content '$5'
    expect(menu_form).to_not have_preview_content 'Bottles'
    expect(menu_form).to_not have_preview_content 'Specials'

    expect(menu_form.menu_preview).to have_font('Courier')

    expect(menu_form.selected_list_named('Taps')).to have_price_shown
    expect(menu_form.selected_list_named('Taps').badge_text).to eq '1 item'

    menu_form.submit

    expect(page).to have_css '[data-test="flash-success"]', text: "Menu created"
    expect(menu_form).to have_download_button
    expect(menu_form).to have_menu_preview
    expect(menu_form.menu_preview).to have_font('Courier')
    expect(menu_form).to have_font_size 8
    expect(menu_form.columns).to eq 2

    establishment_form.load(account_id: account.id, establishment_id: establishment.id)
    expect(establishment_form).to have_menu_named 'Taps - Mini Insert'

    establishment_form.menu_named('Taps - Mini Insert').visit

    expect(menu_form).to be_displayed
    expect(menu_form).to have_selected_list('Taps')

    expect(menu_form.selected_list_named('Taps')).to have_price_shown

    menu_form.name = 'Bottles Large Insert'
    menu_form.remove_list('Taps')
    menu_form.select_list('Bottles')
    menu_form.template = 'Centered'

    expect(menu_form).to have_column_choices_disabled
    expect(menu_form).to_not have_preview_content 'Taps - Mini Insert'
    expect(menu_form).to_not have_preview_content 'Taps'
    expect(menu_form).to_not have_preview_content 'Fulton Sweet Child of Vine'
    expect(menu_form).to have_preview_content 'BOTTLES LARGE INSERT'
    expect(menu_form).to have_preview_content 'Arrogant Bastard'
    expect(menu_form).to have_preview_content '7.5'
    expect(menu_form.selected_list_named('Bottles')).to have_price_shown

    menu_form.hide_prices(list: 'Bottles')

    expect(menu_form).to_not have_preview_content '7.5'

    expect(menu_form).to have_selected_list('Bottles')
    expect(menu_form).to have_available_list('Taps')
    expect(menu_form).to have_available_list('Specials')

    menu_form.submit
    expect(page).to have_css '[data-test="flash-success"]', text: "Menu updated"

    establishment_form.load(account_id: account.id, establishment_id: establishment.id)
    expect(establishment_form.menu_count).to eq 1
    expect(establishment_form).to have_menu_named 'Bottles Large Insert'

    establishment_form.menu_named('Bottles Large Insert').visit
    expect(menu_form).to have_preview_content 'Arrogant Bastard'
    expect(menu_form.selected_list_named('Bottles')).to_not have_price_shown
    expect(menu_form).to_not have_preview_content '7.5'
    expect(menu_form.template).to eq 'Centered'

    menu_form.show_prices(list: 'Bottles')
    menu_form.submit

    expect(menu_form.selected_list_named('Bottles')).to have_price_shown
    expect(menu_form).to have_preview_content '7.5'
  end

  scenario 'staff with establishment access can manage a menu', :js, :admin do
    staff = create :user, account: account
    staff.establishments << establishment

    login staff

    click_link establishment.name

    establishment_form = PageObjects::Admin::EstablishmentForm.new
    establishment_form.add_menu

    menu_form = PageObjects::Admin::MenuForm.new
    expect(menu_form).to be_displayed
    expect(menu_form).to have_no_download_button
    expect(menu_form).to have_menu_preview

    expect(menu_form).to have_available_list('Taps')
    expect(menu_form).to have_available_list('Bottles')
    expect(menu_form).to have_available_list('Specials')

    expect(menu_form.columns).to eq 1

    menu_form.name      = 'Beer'
    menu_form.font      = 'Times-Roman'
    menu_form.template  = 'Basic'
    menu_form.font_size = 7
    menu_form.columns   = 3

    menu_form.select_list('Taps')
    menu_form.select_list('Bottles')
    menu_form.select_list('Specials')

    expect(menu_form.lists_available).to be_empty
    expect(menu_form).to have_selected_list('Taps')
    expect(menu_form).to have_selected_list('Bottles')
    expect(menu_form).to have_selected_list('Specials')
    expect(menu_form).to have_preview_content 'Taps'
    expect(menu_form).to have_preview_content 'Bottles'
    expect(menu_form).to have_preview_content 'Specials'

    menu_form.submit
    expect(page).to have_css '[data-test="flash-success"]', text: "Menu created"
    expect(menu_form).to have_download_button
    expect(menu_form).to have_menu_preview
    expect(menu_form).to have_preview_content 'Taps'
    expect(menu_form).to have_preview_content 'Bottles'
    expect(menu_form).to have_preview_content 'Specials'
    expect(menu_form.menu_preview).to have_font('Times-Roman')
    expect(menu_form).to have_font_size 7
    expect(menu_form.columns).to eq 3
    expect(menu_form.template).to eq 'Basic'

    establishment_form.load(account_id: account.id, establishment_id: establishment.id)
    expect(establishment_form).to have_menu_named 'Beer'

    establishment_form.menu_named('Beer').visit

    expect(menu_form).to be_displayed
    expect(menu_form.lists_available).to be_empty
    expect(menu_form).to have_selected_list('Taps')
    expect(menu_form).to have_selected_list('Bottles')
    expect(menu_form).to have_selected_list('Specials')

    menu_form.name = 'Bottles Large Insert'
    menu_form.template = 'Standard'
    menu_form.columns = 2
    menu_form.remove_list('Taps')
    menu_form.remove_list('Specials')

    expect(menu_form).to have_available_list('Taps')
    expect(menu_form).to have_available_list('Specials')
    expect(menu_form.lists_selected.lists.size).to eq 1

    menu_form.submit
    expect(page).to have_css '[data-test="flash-success"]', text: "Menu updated"

    establishment_form.load(account_id: account.id, establishment_id: establishment.id)
    expect(establishment_form.menu_count).to eq 1
    expect(establishment_form).to have_menu_named 'Bottles Large Insert'

    establishment_form.menu_named('Bottles Large Insert').visit
    expect(menu_form).to be_displayed
    expect(menu_form.template).to eq 'Standard'
    expect(menu_form.columns).to eq 2
    expect(menu_form).to have_selected_list('Bottles')
    expect(menu_form).to have_available_list('Taps')
    expect(menu_form).to have_available_list('Specials')
    expect(menu_form).to have_download_button
    expect(menu_form).to have_menu_preview

    menu_form.delete
    expect(page).to have_css '[data-test="flash-success"]', text: "Menu deleted"
  end

  scenario 'staff without access cannot create a menu' do
    staff = create :user, account: account

    login staff

    visit "/accounts/#{account.id}/establishments/#{establishment.id}/menus/new"

    expect(page).to have_css '[data-test="flash-alert"]', text: 'You are not authorized to access this page.'
  end
end
