require 'spec_helper'

describe WelcomeMailer do
  describe '.welcome_email' do
    let(:mail) { ActionMailer::Base.deliveries.last }

    before do
      ActionMailer::Base.deliveries.clear
      WelcomeMailer.welcome_email('jeff@lebowski.me').deliver_now
    end

    it 'sends an email to the provided address' do
      expect(mail.to).to eq ['jeff@lebowski.me']
    end

    it 'sends text and html' do
      expect(mail.text_part).to_not be_nil
      expect(mail.html_part).to_not be_nil
    end

    it 'includes the right subject' do
      expect(mail.subject).to eq 'Welcome to Evergreen Menus!'
    end

    it 'sends from admin@evergreenmenus.com' do
      expect(mail.from).to eq ['admin@evergreenmenus.com']
    end
  end
end