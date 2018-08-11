require 'spec_helper'

feature 'establishment count is limited by subscription quantity', :admin, :js do
  let(:account) { create :account, :with_subscription, quantity: quantity }
  let(:user) { create :user, :manager, account: account }

  before do
    login user
  end

  feature 'when account subscribes to a plan with quantity 1' do
    let(:quantity) { 1 }

    scenario 'user cannot add more than one establishment' do
      account_details = PageObjects::Admin::AccountDetails.new
      account_details.add_establishment

      form = PageObjects::Admin::EstablishmentForm.new

      form.set_name 'The Lanes'
      form.set_url 'http://thelanes.com/beer-menu'
      form.submit

      expect(form).to be_displayed
      expect(page).to have_css 'div.alert-success', text: 'Establishment created'
      account_details.load id: account.id
      expect(account_details).to_not have_add_establishment_button

      visit "/accounts/#{account.id}/establishments/new"
      expect(account_details).to be_displayed
      expect(page).to have_css '[data-test=flash-alert]', text: 'Your subscription does not allow new establishments at this time.'
    end
  end

  feature 'when account subscribes to a plan with quantity 3' do
    let(:quantity) { 3 }

    scenario 'user cannot add more than three establishments' do
      account_details = PageObjects::Admin::AccountDetails.new
      account_details.add_establishment

      form = PageObjects::Admin::EstablishmentForm.new

      form.set_name 'E1'
      form.set_url 'http://e1.com'
      form.submit

      expect(form).to be_displayed
      expect(page).to have_css 'div.alert-success', text: 'Establishment created'
      account_details.load id: account.id
      account_details.add_establishment

      form.set_name 'E2'
      form.set_url 'http://e2.com'
      form.submit

      expect(form).to be_displayed
      expect(page).to have_css 'div.alert-success', text: 'Establishment created'
      account_details.load id: account.id
      account_details.add_establishment

      form.set_name 'E3'
      form.set_url 'http://e3.com'
      form.submit

      expect(form).to be_displayed
      expect(page).to have_css 'div.alert-success', text: 'Establishment created'
      account_details.load id: account.id

      expect(account_details).to_not have_add_establishment_button

      visit "/accounts/#{account.id}/establishments/new"
      expect(account_details).to be_displayed
      expect(page).to have_css '[data-test=flash-alert]', text: 'Your subscription does not allow new establishments at this time.'
    end
  end
end
