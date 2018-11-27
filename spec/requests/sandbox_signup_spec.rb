require 'spec_helper'

describe 'sandbox signup', :vcr do
  subject { response }

  before do
    ActionMailer::Base.deliveries.clear
    create :plan, :tier_1
  end

  context 'with a new email address' do
    let(:email) { 'mike@restaurant.com' }

    it 'redirects to the new account' do
      post sandbox_signups_path, params: { signup: { email: email } }
      expect(response).to redirect_to account_path(Account.last)
    end

    it 'shows a welcome message' do
      post sandbox_signups_path, params: { signup: { email: email } }
      follow_redirect!
      expect(response.body).to include 'Welcome to Evergreen Menus!'
    end

    it 'creates an establishment and menus' do
      expect {
        post sandbox_signups_path, params: { signup: { email: email } }
      }.to change(Establishment, :count).by(1)
        .and change(WebMenu, :count).by(1)
        .and change(Menu, :count).by(1)
        .and change(DigitalDisplayMenu, :count).by(1)
    end

    it 'sends an email to the Dan and Tam' do
      post sandbox_signups_path, params: { signup: { email: email } }
      mail = ActionMailer::Base.deliveries.last
      expect(mail.to).to eq ['dan@evergreenmenus.com', 'tam@evergreenmenus.com']
      expect(mail.subject).to eq '[Evergreen Menus] New Sandbox Signup'
    end

    context 'when the honeypot parameter "enable" is present' do
      it 'does not create an account' do
        expect {
          post sandbox_signups_path, params: { signup: { email: email, enable: '1' } }
        }.not_to change(Account, :count)
        expect(response).to have_http_status :created
      end
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
