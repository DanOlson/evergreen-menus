require 'spec_helper'

feature 'menu management' do
  let(:account) { create :account }
  let(:establishment) { create :establishment, account: account }

  before do
    %w(Taps Bottles Specials).each do |name|
      establishment.lists.create!({
        name: name
      })
    end
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
    expect(menu_form).to have_no_menu_preview

    expect(menu_form).to have_available_list('Taps')
    expect(menu_form).to have_available_list('Bottles')
    expect(menu_form).to have_available_list('Specials')

    menu_form.name = 'Taps - Mini Insert'
    menu_form.select_list('Taps')

    expect(menu_form).to have_selected_list('Taps')
    expect(menu_form).to have_available_list('Bottles')
    expect(menu_form).to have_available_list('Specials')

    menu_form.submit
    expect(page).to have_css '[data-test="flash-success"]', text: "Menu created"
    expect(menu_form).to have_download_button
    expect(menu_form).to have_menu_preview

    establishment_form.load(account_id: account.id, establishment_id: establishment.id)
    expect(establishment_form).to have_menu_named 'Taps - Mini Insert'

    establishment_form.menu_named('Taps - Mini Insert').visit

    expect(menu_form).to be_displayed
    expect(menu_form).to have_selected_list('Taps')

    menu_form.name = 'Bottles Large Insert'
    menu_form.remove_list('Taps')
    menu_form.select_list('Bottles')

    expect(menu_form).to have_selected_list('Bottles')
    expect(menu_form).to have_available_list('Taps')
    expect(menu_form).to have_available_list('Specials')

    menu_form.submit
    expect(page).to have_css '[data-test="flash-success"]', text: "Menu updated"

    establishment_form.load(account_id: account.id, establishment_id: establishment.id)
    expect(establishment_form.menu_count).to eq 1
    expect(establishment_form).to have_menu_named 'Bottles Large Insert'
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
    expect(menu_form).to have_no_menu_preview

    expect(menu_form).to have_available_list('Taps')
    expect(menu_form).to have_available_list('Bottles')
    expect(menu_form).to have_available_list('Specials')

    menu_form.name = 'Beer'

    menu_form.select_list('Taps')
    menu_form.select_list('Bottles')
    menu_form.select_list('Specials')

    expect(menu_form.lists_available).to be_empty
    expect(menu_form).to have_selected_list('Taps')
    expect(menu_form).to have_selected_list('Bottles')
    expect(menu_form).to have_selected_list('Specials')

    menu_form.submit
    expect(page).to have_css '[data-test="flash-success"]', text: "Menu created"
    expect(menu_form).to have_download_button
    expect(menu_form).to have_menu_preview

    establishment_form.load(account_id: account.id, establishment_id: establishment.id)
    expect(establishment_form).to have_menu_named 'Beer'

    establishment_form.menu_named('Beer').visit

    expect(menu_form).to be_displayed
    expect(menu_form.lists_available).to be_empty
    expect(menu_form).to have_selected_list('Taps')
    expect(menu_form).to have_selected_list('Bottles')
    expect(menu_form).to have_selected_list('Specials')

    menu_form.name = 'Bottles Large Insert'
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
