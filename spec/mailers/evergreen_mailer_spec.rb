require 'spec_helper'

describe EvergreenMailer do
  before do
    ActionMailer::Base.deliveries.clear
  end

  describe '#new_sandbox_signup_email' do
    let(:mail) do
      ActionMailer::Base.deliveries.last
      EvergreenMailer.new_sandbox_signup_email('jeff@lebowski.me').deliver_now
    end

    it 'sends an email to Dan and Tam' do
      expect(mail.to).to eq ['dan@evergreenmenus.com', 'tam@evergreenmenus.com']
    end

    it 'has the correct subject' do
      expect(mail.subject).to eq '[Evergreen Menus] New Sandbox Signup'
    end

    it 'mentions the email address that signed up' do
      expect(mail.text_part.body.decoded).to include 'jeff@lebowski.me'
    end
  end
end
