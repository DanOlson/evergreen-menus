require 'spec_helper'

feature 'Google OAuth2' do
  let(:account) { create :account, :with_subscription, name: 'Green Plate, LLC' }
  let(:account_admin) { create :user, :account_admin, account: account }
  let(:staff) { create :user, account: account }

  scenario 'account admin can connect their account with Google', :js, :admin do
    login account_admin
    account_details = PageObjects::Admin::AccountDetails.new
    expect(account_details).to be_displayed
    expect(account_details).to have_connect_with_google_button
    expect(account_details).to have_google_disabled_status
    expect(account_details).to_not have_disconnect_from_google_button
    expect(account_details).to_not have_edit_google_link
  end

  scenario 'account admin can disconnect their account from Google', :js, :admin do
    AuthToken.google.for_account(account).create!({
      access_token: 'asdf',
      token_data: {
        access_token: 'asdf',
        refresh_token: 'qwer',
        expires_in: 3600,
        token_type: 'Bearer'
      }
    })

    login account_admin
    account_details = PageObjects::Admin::AccountDetails.new
    expect(account_details).to be_displayed
    expect(account_details).to have_edit_google_link
    expect(account_details).to have_disconnect_from_google_button
    expect(account_details).to have_google_enabled_status
    expect(account_details).to_not have_connect_with_google_button
  end

  scenario 'staff cannot view Google connect/disconnect feature', :js, :admin do
    login staff
    account_details = PageObjects::Admin::AccountDetails.new
    expect(account_details).to be_displayed
    expect(account_details).to_not have_connect_with_google_button
    expect(account_details).to_not have_web_integrations
  end
end
