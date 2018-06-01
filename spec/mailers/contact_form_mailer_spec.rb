require 'spec_helper'

describe ContactFormMailer, type: :mailer do
  describe '#contact_form_email' do
    let(:form_data) do
      {
        name: 'The Dude',
        email: 'dude@lebowski.me',
        message: "You got the wrong guy, man! My name's The Dude!"
      }
    end
    let(:email) { ActionMailer::Base.deliveries.last }

    before do
      ContactFormMailer.contact_form_email(form_data).deliver_now
    end

    it 'sends an email' do
      expect(ActionMailer::Base.deliveries.size).to eq 1
    end

    it 'sends an email to admin@evergreenmenus.com' do
      expect(email.to).to eq ['admin@evergreenmenus.com']
    end

    it 'sends an email from the do-not-reply address' do
      expect(email.from).to eq ['do-not-reply@evergreenmenus.com']
    end

    it 'sends an email with the expected subject' do
      expect(email.subject).to eq '[Evergreen Menus] New Contact Form Submission'
    end

    it 'sends a multipart email' do
      expect(email.content_type).to include 'multipart/alternative'
    end

    it 'sends an email that includes the form data content' do
      decoded = email.text_part.decoded
      expect(decoded).to include 'The Dude'
      expect(decoded).to include 'dude@lebowski.me'
      expect(decoded).to include "You got the wrong guy, man! My name's The Dude!"
    end
  end
end
