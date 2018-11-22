require 'spec_helper'

describe 'sandbox signup', :vcr do
  subject { response }

  before do
    create :plan, :tier_1
  end

  context 'with a new email address' do
    let(:email) { 'mike@restaurant.com' }

    before do
      post sandbox_signups_path, params: { signup: { email: email } }
    end

    it 'redirects to the new account' do
      expect(response).to redirect_to account_path(Account.last)
    end

    it 'shows a welcome message' do
      follow_redirect!
      expect(response.body).to include 'Welcome to Evergreen Menus!'
    end
  end

  context 'with an email address that has already been used' do
    let(:email) { 'cheryl@restaurant.com' }

    before do
      create :user, email: email
      post sandbox_signups_path, params: { signup: { email: email } }
    end

    it 'redirects' do
      expect(response).to redirect_to 'https://evergreenmenus.com?alert=Email%20has%20already%20been%20taken'
    end
  end
end
