require 'spec_helper'

feature 'Online Menu management' do
  let(:account) { create :account, :with_subscription }
  let(:establishment) { create :establishment, account: account }

  before do
    taps_list = establishment.lists.create!({
      name: 'Taps'
    })
    taps_list.beers.create!(
      name: 'Fulton Sweet Child of Vine',
      price: '5',
      position: 0
    )
    milk_stout = taps_list.beers.create!(
      name: 'Nitro Milk Stout',
      price: '6.50',
      position: 1
    )
    taps_list.beers.create!(
      name: 'Coors Light',
      price_options: [
        PriceOption.new(price: '4', unit: 'Pint'),
        PriceOption.new(price: '6.50', unit: 'Quart')
      ],
      position: 2
    )
    bottles_list = establishment.lists.create!({
      name: 'Bottles'
    })
    bottles_list.beers.create!(
      name: 'Arrogant Bastard',
      price: '7.50',
      position: 0
    )
    File.open(file_fixture('indeed-logo.png')) do |image|
      milk_stout.image.attach({
        io: image,
        filename: 'indeed-logo.png',
        content_type: 'image/png'
      })
    end
    create :online_menu, establishment: establishment
  end

  def run_test(user)
    login user

    establishment_form = PageObjects::Admin::EstablishmentForm.new
    establishment_form.load({
      account_id: establishment.account_id,
      establishment_id: establishment.id
    })
    expect(establishment_form).to have_online_menu
    establishment_form.online_menu.visit

    online_menu_form = PageObjects::Admin::OnlineMenuForm.new
    # Query the form
    expect(online_menu_form).to be_displayed
    expect(online_menu_form).to have_available_list 'Taps'
    expect(online_menu_form).to have_available_list 'Bottles'

    available_taps_list = online_menu_form.available_list_named('Taps')
    available_bottles_list = online_menu_form.available_list_named('Bottles')

    expect(available_taps_list.badge_text).to eq '3 items'
    expect(available_bottles_list.badge_text).to eq '1 item'

    # Manipulate the form
    online_menu_form.select_list 'Taps'
    online_menu_form.select_list 'Bottles'

    # Query form again
    expect(online_menu_form).to have_selected_list 'Taps'
    expect(online_menu_form).to have_selected_list 'Bottles'
    expect(online_menu_form.selected_list_named('Taps')).to have_price_shown
    expect(online_menu_form.selected_list_named('Bottles')).to have_price_shown

    selected_taps_list = online_menu_form.selected_list_named('Taps')
    selected_bottles_list = online_menu_form.selected_list_named('Bottles')

    expect(selected_taps_list.badge_text).to eq '3 items'
    expect(selected_bottles_list.badge_text).to eq '1 item'

    # Query preview
    expect(online_menu_form.preview).to have_list 'Taps'
    expect(online_menu_form.preview).to have_list 'Bottles'
    preview_taps_list = online_menu_form.preview.list_named('Taps')
    preview_bottles_list = online_menu_form.preview.list_named('Bottles')
    expect(preview_taps_list).to have_item 'Fulton Sweet Child of Vine'
    expect(preview_taps_list).to have_item 'Nitro Milk Stout'
    expect(preview_bottles_list).to have_item 'Arrogant Bastard'
    expect(preview_taps_list.item_named('Fulton Sweet Child of Vine').price).to eq '5'
    expect(preview_taps_list.item_named('Nitro Milk Stout').price).to eq '6.5'
    expect(preview_taps_list.item_named('Coors Light').price).to eq '4 / 6.5'
    expect(preview_bottles_list.item_named('Arrogant Bastard').price).to eq '7.5'

    # Submit
    online_menu_form.submit

    expect(page).to have_css '[data-test="flash-success"]', text: 'Online Menu updated'

    # Verify form submission was persisted
    expect(online_menu_form).to have_selected_list 'Taps'
    expect(online_menu_form).to have_selected_list 'Bottles'

    # Manipulate the form some more
    online_menu_form.remove_list 'Bottles'
    online_menu_form.hide_prices(list: 'Taps')

    # Query the form
    expect(online_menu_form).to have_selected_list 'Taps'
    expect(online_menu_form).to have_available_list 'Bottles'
    expect(online_menu_form).to_not have_selected_list 'Bottles'
    expect(online_menu_form).to_not have_available_list 'Taps'
    expect(online_menu_form.selected_list_named('Taps')).to_not have_price_shown

    # Query the preview
    expect(online_menu_form.preview).to have_list 'Taps'
    expect(online_menu_form.preview).to_not have_list 'Bottles'
    preview_taps_list = online_menu_form.preview.list_named('Taps')
    expect(preview_taps_list.item_named('Fulton Sweet Child of Vine')).to_not have_price
    expect(preview_taps_list.item_named('Fulton Sweet Child of Vine')).to_not have_image
    expect(preview_taps_list.item_named('Nitro Milk Stout')).to_not have_price
    expect(preview_taps_list.item_named('Nitro Milk Stout')).to_not have_image

    # Submit new changes
    online_menu_form.submit

    expect(page).to have_css '[data-test="flash-success"]', text: 'Online Menu updated'

    # Verify form submission was persisted
    expect(online_menu_form).to have_selected_list 'Taps'
    expect(online_menu_form).to have_available_list 'Bottles'
    expect(online_menu_form).to_not have_selected_list 'Bottles'
    expect(online_menu_form).to_not have_available_list 'Taps'
    expect(online_menu_form.selected_list_named('Taps')).to_not have_price_shown

    # Verify preview
    expect(online_menu_form.preview).to have_list 'Taps'
    expect(online_menu_form.preview).to_not have_list 'Bottles'
    preview_taps_list = online_menu_form.preview.list_named('Taps')
    expect(preview_taps_list.item_named('Fulton Sweet Child of Vine')).to_not have_price
    expect(preview_taps_list.item_named('Nitro Milk Stout')).to_not have_price

    ###
    # Adding images
    online_menu_form.selected_list_named('Taps').choose_images 'Nitro Milk Stout'
    expect(online_menu_form.selected_list_named('Taps')).to have_chosen_images 'Nitro Milk Stout'
    preview_taps_list = online_menu_form.preview.list_named('Taps')
    expect(preview_taps_list.item_named('Fulton Sweet Child of Vine')).to_not have_image
    expect(preview_taps_list.item_named('Nitro Milk Stout')).to have_image

    online_menu_form.selected_list_named('Taps').image_option_named('Nitro Milk Stout').remove
    preview_taps_list = online_menu_form.preview.list_named('Taps')
    expect(preview_taps_list.item_named('Nitro Milk Stout')).to_not have_image

    online_menu_form.selected_list_named('Taps').choose_images 'Nitro Milk Stout'
    preview_taps_list = online_menu_form.preview.list_named('Taps')
    expect(preview_taps_list.item_named('Nitro Milk Stout')).to have_image

    online_menu_form.submit
    expect(online_menu_form.selected_list_named('Taps')).to have_chosen_images 'Nitro Milk Stout'
    preview_taps_list = online_menu_form.preview.list_named('Taps')
    expect(preview_taps_list.item_named('Nitro Milk Stout')).to have_image

    ###
    # Display name
    taps_list = online_menu_form.selected_list_named 'Taps'
    taps_list.display_name = "What's on tap"
    expect(online_menu_form.preview).to have_list "What's on tap"
    expect(online_menu_form.preview).to_not have_list 'Taps'
    online_menu_form.submit

    taps_list = online_menu_form.selected_list_named 'Taps'
    expect(taps_list.display_name).to eq "What's on tap"
  end

  scenario 'account admin can manage the Online Menu for their establishment', :js, :admin do
    account_admin = create :user, :account_admin, account: account

    run_test account_admin
  end

  scenario 'staff with establishment access can manage the Online Menu', :js, :admin do
    staff = create :user, account: account
    staff.establishments << establishment

    run_test staff
  end

  scenario 'staff without access cannot access Online Menu', :js, :admin do
    staff = create :user, account: account
    login staff
    online_menu = establishment.online_menu
    visit "/accounts/#{account.id}/establishments/#{establishment.id}/online_menus/#{online_menu.id}/edit"

    online_menu_form = PageObjects::Admin::OnlineMenuForm.new
    expect(online_menu_form).to_not be_displayed
    expect(page).to have_css '[data-test="flash-alert"]', text: 'You are not authorized to access this page'
  end
end
