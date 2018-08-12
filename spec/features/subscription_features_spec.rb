require 'spec_helper'

feature 'subscribing to select plans unlocks features', :admin, :js do
  let(:account) { create :account }
  let(:user) { create :user, :manager, account: account }

  before do
    Subscription.create!({
      account: account,
      plan: plan,
      quantity: 1,
      status: :active,
      remote_id: 'sub_123'
    })
    login user
  end

  feature 'with tier 1 plan' do
    let(:plan) { create :plan, :tier_1 }

    scenario 'account cannot access web integrations' do
      account_details = PageObjects::Admin::AccountDetails.new
      account_details.load(id: account.id)
      expect(account_details).to be_displayed
      expect(account_details).to_not have_connect_with_google_button
      expect(account_details).to_not have_connect_with_facebook_button
      expect(account_details).to_not have_facebook_disabled_status
    end

    scenario 'establishment with an online menu cannot view it' do
      establishment = create :establishment, account: account
      online_menu = create :online_menu, establishment: establishment
      account.establishments << establishment
      establishment_form = PageObjects::Admin::EstablishmentForm.new
      establishment_form.load(account_id: account.id, establishment_id: establishment.id)
      expect(establishment_form).to be_displayed
      expect(establishment_form).to_not have_online_menu

      online_menu_form = PageObjects::Admin::OnlineMenuForm.new
      online_menu_form.load({
        account_id: account.id,
        establishment_id: establishment.id,
        online_menu_id: online_menu.id
      })
      account_details = PageObjects::Admin::AccountDetails.new
      expect(account_details).to be_displayed
      expect(page).to have_css '[data-test=flash-alert]', text: 'Your subscription does not include web integrations.'
    end
  end

  feature 'with tier 2 plan' do
    let(:plan) { create :plan, :tier_2 }

    scenario 'account can access web integrations' do
      account_details = PageObjects::Admin::AccountDetails.new
      account_details.load(id: account.id)
      expect(account_details).to be_displayed
      expect(account_details).to have_connect_with_google_button
      expect(account_details).to have_connect_with_facebook_button
      expect(account_details).to have_facebook_disabled_status
    end
  end

  feature 'with tier 3 plan' do
    let(:plan) { create :plan, :tier_3 }

    scenario 'account can access web integrations' do
      account_details = PageObjects::Admin::AccountDetails.new
      account_details.load(id: account.id)
      expect(account_details).to be_displayed
      expect(account_details).to have_connect_with_google_button
      expect(account_details).to have_connect_with_facebook_button
      expect(account_details).to have_facebook_disabled_status
    end
  end
end
