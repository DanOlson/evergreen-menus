require 'spec_helper'

feature 'menu management' do
  let(:account) { create :account }
  let!(:establishment) { create :establishment, account: account }

  scenario 'manager can create a menu', :js, :admin do
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
    expect(page).to have_css "div.alert-success", text: "Menu created"
    expect(establishment_form).to have_menu_named 'Taps - Mini Insert'
  end

  scenario 'staff with establishment access can create a menu' do
  end

  scenario 'staff without access cannot create a menu' do
  end
end
