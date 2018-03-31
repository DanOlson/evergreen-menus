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
      price: '5',
      position: 0
    )
    taps_list.beers.create!(
      name: 'Nitro Milk Stout',
      price: '6.50',
      position: 1
    )
    bottles_list = establishment.lists.create!({
      name: 'Bottles'
    })
    bottles_list.beers.create!(
      name: 'Arrogant Bastard',
      price: '7.50',
      position: 0
    )
  end

  def run_test(user)
    login user
    click_link establishment.name

    establishment_form = PageObjects::Admin::EstablishmentForm.new
    establishment_form.add_web_menu

    web_menu_form = PageObjects::Admin::WebMenuForm.new
    # Query the form
    expect(web_menu_form).to be_displayed
    expect(web_menu_form).to have_available_list 'Taps'
    expect(web_menu_form).to have_available_list 'Bottles'

    available_taps_list = web_menu_form.available_list_named('Taps')
    available_bottles_list = web_menu_form.available_list_named('Bottles')

    expect(available_taps_list.badge_text).to eq '2 items'
    expect(available_bottles_list.badge_text).to eq '1 item'

    # Manipulate the form
    web_menu_form.name = 'Test Menu'
    web_menu_form.select_list 'Taps'
    web_menu_form.select_list 'Bottles'

    # Query form again
    expect(web_menu_form).to have_selected_list 'Taps'
    expect(web_menu_form).to have_selected_list 'Bottles'
    expect(web_menu_form.selected_list_named('Taps')).to have_price_shown
    expect(web_menu_form.selected_list_named('Bottles')).to have_price_shown

    selected_taps_list = web_menu_form.selected_list_named('Taps')
    selected_bottles_list = web_menu_form.selected_list_named('Bottles')

    expect(selected_taps_list.badge_text).to eq '2 items'
    expect(selected_bottles_list.badge_text).to eq '1 item'

    # Query preview
    expect(web_menu_form.preview).to have_list 'Taps'
    expect(web_menu_form.preview).to have_list 'Bottles'
    preview_taps_list = web_menu_form.preview.list_named('Taps')
    preview_bottles_list = web_menu_form.preview.list_named('Bottles')
    expect(preview_taps_list).to have_item 'Fulton Sweet Child of Vine'
    expect(preview_taps_list).to have_item 'Nitro Milk Stout'
    expect(preview_bottles_list).to have_item 'Arrogant Bastard'
    expect(preview_taps_list.item_named('Fulton Sweet Child of Vine').price).to eq '$5'
    expect(preview_taps_list.item_named('Nitro Milk Stout').price).to eq '$6.50'
    expect(preview_bottles_list.item_named('Arrogant Bastard').price).to eq '$7.50'

    # What's up with the preview styles?
    web_menu_form.show_help_text
    expect(web_menu_form).to have_help_text
    expected_help_text = 'The preview content shown here is unstyled. The styles from your site will apply to this menu once you add the embed code to your site.'
    expect(web_menu_form.help_text_content).to eq expected_help_text

    # Oh, got it.
    web_menu_form.hide_help_text
    expect(web_menu_form).to_not have_help_text

    # Submit
    web_menu_form.submit

    expect(page).to have_css '[data-test="flash-success"]', text: 'Web menu created'

    # Verify form submission was persisted
    expect(web_menu_form.name).to eq 'Test Menu'
    expect(web_menu_form).to have_selected_list 'Taps'
    expect(web_menu_form).to have_selected_list 'Bottles'

    # Manipulate the form some more
    web_menu_form.name = 'Beer Menu'
    web_menu_form.remove_list 'Bottles'
    web_menu_form.hide_prices(list: 'Taps')

    # Query the form
    expect(web_menu_form).to have_selected_list 'Taps'
    expect(web_menu_form).to have_available_list 'Bottles'
    expect(web_menu_form).to_not have_selected_list 'Bottles'
    expect(web_menu_form).to_not have_available_list 'Taps'
    expect(web_menu_form.selected_list_named('Taps')).to_not have_price_shown

    # Query the preview
    expect(web_menu_form.preview).to have_list 'Taps'
    expect(web_menu_form.preview).to_not have_list 'Bottles'
    preview_taps_list = web_menu_form.preview.list_named('Taps')
    expect(preview_taps_list.item_named('Fulton Sweet Child of Vine')).to_not have_price
    expect(preview_taps_list.item_named('Nitro Milk Stout')).to_not have_price

    # Submit new changes
    web_menu_form.submit

    expect(page).to have_css '[data-test="flash-success"]', text: 'Web menu updated'

    # Verify form submission was persisted
    expect(web_menu_form.name).to eq 'Beer Menu'
    expect(web_menu_form).to have_selected_list 'Taps'
    expect(web_menu_form).to have_available_list 'Bottles'
    expect(web_menu_form).to_not have_selected_list 'Bottles'
    expect(web_menu_form).to_not have_available_list 'Taps'
    expect(web_menu_form.selected_list_named('Taps')).to_not have_price_shown

    # Verify preview
    expect(web_menu_form.preview).to have_list 'Taps'
    expect(web_menu_form.preview).to_not have_list 'Bottles'
    preview_taps_list = web_menu_form.preview.list_named('Taps')
    expect(preview_taps_list.item_named('Fulton Sweet Child of Vine')).to_not have_price
    expect(preview_taps_list.item_named('Nitro Milk Stout')).to_not have_price

    ###
    # Restricted availability
    expect(web_menu_form).to_not have_availability_start_time_input
    expect(web_menu_form).to_not have_availability_end_time_input

    web_menu_form.restrict_availability = true

    expect(web_menu_form).to have_availability_start_time_input
    expect(web_menu_form).to have_availability_end_time_input

    web_menu_form.availability_start = {
      hour: '04',
      minute: '30',
      meridiem: 'PM'
    }
    web_menu_form.availability_end = {
      hour: '11',
      minute: '00',
      meridiem: 'PM'
    }
    expect(web_menu_form.availability_start).to eq '04:30 PM'
    expect(web_menu_form.availability_end).to eq '11:00 PM'
    expect(web_menu_form.preview).to have_availability_restriction '4:30 pm - 11:00 pm'

    web_menu_form.submit

    expect(page).to have_css '[data-test="flash-success"]', text: 'Web menu updated'
    expect(web_menu_form).to have_restricted_availability
    expect(web_menu_form.availability_start).to eq '04:30 PM'
    expect(web_menu_form.availability_end).to eq '11:00 PM'
    expect(web_menu_form.preview).to have_availability_restriction '4:30 pm - 11:00 pm'

    web_menu_form.restrict_availability = false
    expect(web_menu_form).to_not have_availability_start_time_input
    expect(web_menu_form).to_not have_availability_end_time_input

    web_menu_form.submit

    expect(web_menu_form).to_not have_restricted_availability
    expect(web_menu_form).to_not have_availability_start_time_input
    expect(web_menu_form).to_not have_availability_end_time_input
    expect(web_menu_form.preview).to_not have_availability_restriction

    ###
    # Warn of unsaved changes if list linked is clicked
    dismiss_confirm do
      web_menu_form.selected_list_named('Taps').visit
    end
    expect(web_menu_form).to be_displayed
    dismiss_confirm do
      web_menu_form.available_list_named('Bottles').visit
    end
    expect(web_menu_form).to be_displayed

    ###
    # TEST DELETE?
  end

  scenario 'manager can manage a web menu for their establishments', :js, :admin do
    manager = create :user, :manager, account: account

    run_test manager

    web_menu_form = PageObjects::Admin::WebMenuForm.new
    expect(web_menu_form).to have_toggle_embed_code_button
    web_menu_form.show_embed_code_options

    expect(web_menu_form).to have_canonical_embed_code
    expect(web_menu_form).to_not have_amp_head_embed_code
    expect(web_menu_form).to_not have_amp_body_embed_code

    web_menu_form.show_amp_embed_code

    expect(web_menu_form).to have_amp_head_embed_code
    expect(web_menu_form).to have_amp_body_embed_code
    expect(web_menu_form).to_not have_canonical_embed_code

    web_menu_form.show_canonical_embed_code

    expect(web_menu_form).to have_canonical_embed_code
    expect(web_menu_form).to_not have_amp_head_embed_code
    expect(web_menu_form).to_not have_amp_body_embed_code
  end

  scenario 'staff with establishment access can manage a web menu', :js, :admin do
    staff = create :user, account: account
    staff.establishments << establishment

    run_test staff
    # web_menu_form = PageObjects::Admin::WebMenuForm.new
    # expect(web_menu_form).to_not have_toggle_embed_code_button
  end

  scenario 'staff without access cannot access web menu', :js, :admin do
    staff = create :user, account: account
    login staff
    visit "/accounts/#{account.id}/establishments/#{establishment.id}/web_menus/new"

    web_menu_form = PageObjects::Admin::WebMenuForm.new
    expect(web_menu_form).to_not be_displayed
    expect(page).to have_css '[data-test="flash-alert"]', text: 'You are not authorized to access this page'
  end
end
