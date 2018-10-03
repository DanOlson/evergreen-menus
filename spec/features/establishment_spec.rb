require 'spec_helper'

feature 'establishment management' do
  let(:account) { create :account, :with_subscription }
  let(:user) { create :user, :manager, account: account }

  scenario 'creating an establishment' do
    login user
    find('[data-test="add-establishment"]').click

    form = PageObjects::Admin::EstablishmentForm.new

    form.set_name 'The Lanes'
    form.set_url 'http://thelanes.com/beer-menu'
    form.set_logo Rails.root.join('spec/fixtures/files/the-jesus.png')
    form.submit

    expect(form).to be_displayed
    expect(page).to have_css "div.alert-success", text: "Establishment created"
    expect(form).to have_logo_label 'the-jesus.png'
  end

  scenario 'editing an establishment', :js, :admin do
    establishment = create :establishment, account: account
    login user

    click_link establishment.name

    form = PageObjects::Admin::EstablishmentForm.new

    form.set_name 'Sobchak Security'
    form.set_url 'http://sobsec.com/beer-menu'
    form.set_logo Rails.root.join('spec/fixtures/files/the-jesus.png')
    form.submit

    expect(form).to be_displayed
    expect(page).to have_css "div.alert-success", text: "Establishment updated"
    expect(page).to have_selector "input[value='Sobchak Security']"
    expect(form).to have_logo_label 'the-jesus.png'

    ###
    # Reload the page so the flash goes away
    form.load account_id: account.id, establishment_id: establishment.id

    form.set_logo Rails.root.join('spec/fixtures/files/dinner-menu.pdf')
    expect(form).to_not have_valid_logo

    form.submit
    expect(page).to_not have_css "div.alert-success", text: "Establishment updated"
    expect(form).to_not have_valid_logo

    form.set_logo Rails.root.join('spec/fixtures/files/logos/burger-man.png')
    expect(form).to have_valid_logo

    form.submit
    expect(page).to have_css "div.alert-success", text: "Establishment updated"
    expect(form).to have_logo_label 'burger-man.png'
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
    sleep 0.25
    expect(form.lists_panel).to have_no_help_text

    form.toggle_menus_help
    expect(form.menus_panel).to have_help_text
    form.toggle_menus_help
    sleep 0.4
    expect(form.menus_panel).to have_no_help_text
  end

  scenario 'Online Menu appears in menu list when it exists' do
    establishment = create :establishment, account: account
    create :online_menu, establishment: establishment
    login user

    establishment_form = PageObjects::Admin::EstablishmentForm.new
    establishment_form.load({
      account_id: establishment.account_id,
      establishment_id: establishment.id
    })
    expect(establishment_form).to have_online_menu
  end
end
