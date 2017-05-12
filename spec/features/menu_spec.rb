require 'spec_helper'

feature 'menu management' do
  let(:account) { create :account }
  let!(:establishment) { create :establishment, account: account }

  scenario 'manager can manage a menu for their account', :js, :admin do
    manager = create :user, :manager, account: account

    login manager

    click_link establishment.name

    establishment_form = PageObjects::Admin::EstablishmentForm.new
    establishment_form.add_menu

    menu_form = PageObjects::Admin::MenuForm.new
    expect(menu_form).to be_displayed

    menu_form.name = 'Taps - Mini Insert'

    menu_form.submit

    expect(establishment_form).to be_displayed
    expect(page).to have_css '[data-test="flash-success"]', text: "Menu created"
    expect(establishment_form).to have_menu_named 'Taps - Mini Insert'

    establishment_form.menu_named('Taps - Mini Insert').visit

    expect(menu_form).to be_displayed

    menu_form.name = 'Bottles Large Insert'
    menu_form.submit

    expect(establishment_form).to be_displayed
    expect(page).to have_css '[data-test="flash-success"]', text: "Menu updated"
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

    menu_form.name = 'Taps - Mini Insert'

    menu_form.submit

    expect(establishment_form).to be_displayed
    expect(page).to have_css '[data-test="flash-success"]', text: "Menu created"
    expect(establishment_form).to have_menu_named 'Taps - Mini Insert'

    establishment_form.menu_named('Taps - Mini Insert').visit

    expect(menu_form).to be_displayed

    menu_form.name = 'Bottles Large Insert'
    menu_form.submit

    expect(establishment_form).to be_displayed
    expect(page).to have_css '[data-test="flash-success"]', text: "Menu updated"
    expect(establishment_form.menu_count).to eq 1
    expect(establishment_form).to have_menu_named 'Bottles Large Insert'
  end

  scenario 'staff without access cannot create a menu' do
    staff = create :user, account: account

    login staff

    visit "/accounts/#{account.id}/establishments/#{establishment.id}/menus/new"

    expect(page).to have_css '[data-test="flash-alert"]', text: 'You are not authorized to access this page.'
  end
end
