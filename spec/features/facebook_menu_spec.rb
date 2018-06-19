require 'spec_helper'

# feature 'Google Menu management' do
#   let(:account) { create :account }
#   let(:establishment) { create :establishment, account: account }

#   before do
#     taps_list = establishment.lists.create!({
#       name: 'Taps'
#     })
#     taps_list.beers.create!(
#       name: 'Fulton Sweet Child of Vine',
#       price: '5',
#       position: 0
#     )
#     taps_list.beers.create!(
#       name: 'Nitro Milk Stout',
#       price: '6.50',
#       position: 1
#     )
#     bottles_list = establishment.lists.create!({
#       name: 'Bottles'
#     })
#     bottles_list.beers.create!(
#       name: 'Arrogant Bastard',
#       price: '7.50',
#       position: 0
#     )
#     create :google_menu, name: 'My Google Menu', establishment: establishment
#   end

#   def run_test(user)
#     login user

#     establishment_form = PageObjects::Admin::EstablishmentForm.new
#     establishment_form.load({
#       account_id: establishment.account_id,
#       establishment_id: establishment.id
#     })
#     expect(establishment_form).to have_google_menu
#     establishment_form.google_menu.visit

#     google_menu_form = PageObjects::Admin::GoogleMenuForm.new
#     # Query the form
#     expect(google_menu_form).to be_displayed
#     expect(google_menu_form).to have_available_list 'Taps'
#     expect(google_menu_form).to have_available_list 'Bottles'

#     available_taps_list = google_menu_form.available_list_named('Taps')
#     available_bottles_list = google_menu_form.available_list_named('Bottles')

#     expect(available_taps_list.badge_text).to eq '2 items'
#     expect(available_bottles_list.badge_text).to eq '1 item'

#     # Manipulate the form
#     google_menu_form.select_list 'Taps'
#     google_menu_form.select_list 'Bottles'

#     # Query form again
#     expect(google_menu_form).to have_selected_list 'Taps'
#     expect(google_menu_form).to have_selected_list 'Bottles'
#     expect(google_menu_form.selected_list_named('Taps')).to have_price_shown
#     expect(google_menu_form.selected_list_named('Bottles')).to have_price_shown

#     selected_taps_list = google_menu_form.selected_list_named('Taps')
#     selected_bottles_list = google_menu_form.selected_list_named('Bottles')

#     expect(selected_taps_list.badge_text).to eq '2 items'
#     expect(selected_bottles_list.badge_text).to eq '1 item'

#     # Query preview
#     expect(google_menu_form.preview).to have_list 'Taps'
#     expect(google_menu_form.preview).to have_list 'Bottles'
#     preview_taps_list = google_menu_form.preview.list_named('Taps')
#     preview_bottles_list = google_menu_form.preview.list_named('Bottles')
#     expect(preview_taps_list).to have_item 'Fulton Sweet Child of Vine'
#     expect(preview_taps_list).to have_item 'Nitro Milk Stout'
#     expect(preview_bottles_list).to have_item 'Arrogant Bastard'
#     expect(preview_taps_list.item_named('Fulton Sweet Child of Vine').price).to eq '$5'
#     expect(preview_taps_list.item_named('Nitro Milk Stout').price).to eq '$6.50'
#     expect(preview_bottles_list.item_named('Arrogant Bastard').price).to eq '$7.50'

#     # What's up with the preview styles?
#     google_menu_form.show_help_text
#     expect(google_menu_form).to have_help_text
#     expected_help_text = "The preview content shown here is unstyled. Google's own styles will apply to the content shown below."
#     expect(google_menu_form.help_text_content).to eq expected_help_text

#     # Oh, got it.
#     google_menu_form.hide_help_text
#     expect(google_menu_form).to_not have_help_text

#     # Submit
#     google_menu_form.submit

#     expect(page).to have_css '[data-test="flash-success"]', text: 'Google Menu updated'

#     # Verify form submission was persisted
#     expect(google_menu_form).to have_selected_list 'Taps'
#     expect(google_menu_form).to have_selected_list 'Bottles'

#     # Manipulate the form some more
#     google_menu_form.remove_list 'Bottles'
#     google_menu_form.hide_prices(list: 'Taps')

#     # Query the form
#     expect(google_menu_form).to have_selected_list 'Taps'
#     expect(google_menu_form).to have_available_list 'Bottles'
#     expect(google_menu_form).to_not have_selected_list 'Bottles'
#     expect(google_menu_form).to_not have_available_list 'Taps'
#     expect(google_menu_form.selected_list_named('Taps')).to_not have_price_shown

#     # Query the preview
#     expect(google_menu_form.preview).to have_list 'Taps'
#     expect(google_menu_form.preview).to_not have_list 'Bottles'
#     preview_taps_list = google_menu_form.preview.list_named('Taps')
#     expect(preview_taps_list.item_named('Fulton Sweet Child of Vine')).to_not have_price
#     expect(preview_taps_list.item_named('Nitro Milk Stout')).to_not have_price

#     # Submit new changes
#     google_menu_form.submit

#     expect(page).to have_css '[data-test="flash-success"]', text: 'Google Menu updated'

#     # Verify form submission was persisted
#     expect(google_menu_form).to have_selected_list 'Taps'
#     expect(google_menu_form).to have_available_list 'Bottles'
#     expect(google_menu_form).to_not have_selected_list 'Bottles'
#     expect(google_menu_form).to_not have_available_list 'Taps'
#     expect(google_menu_form.selected_list_named('Taps')).to_not have_price_shown

#     # Verify preview
#     expect(google_menu_form.preview).to have_list 'Taps'
#     expect(google_menu_form.preview).to_not have_list 'Bottles'
#     preview_taps_list = google_menu_form.preview.list_named('Taps')
#     expect(preview_taps_list.item_named('Fulton Sweet Child of Vine')).to_not have_price
#     expect(preview_taps_list.item_named('Nitro Milk Stout')).to_not have_price
#   end

#   scenario 'manager can manage the Google Menu for their establishment', :js, :admin do
#     manager = create :user, :manager, account: account

#     run_test manager
#   end

#   scenario 'staff with establishment access can manage the Google Menu', :js, :admin do
#     staff = create :user, account: account
#     staff.establishments << establishment

#     run_test staff
#   end

#   scenario 'staff without access cannot access Google Menu', :js, :admin do
#     staff = create :user, account: account
#     login staff
#     google_menu = establishment.google_menu
#     visit "/accounts/#{account.id}/establishments/#{establishment.id}/google_menus/#{google_menu.id}/edit"

#     google_menu_form = PageObjects::Admin::GoogleMenuForm.new
#     expect(google_menu_form).to_not be_displayed
#     expect(page).to have_css '[data-test="flash-alert"]', text: 'You are not authorized to access this page'
#   end
# end
