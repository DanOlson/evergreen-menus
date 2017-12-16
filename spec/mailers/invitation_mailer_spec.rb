require "spec_helper"

describe InvitationMailer, type: :mailer do
  describe '#invitation_email' do
    let(:account) { build :account, name: 'The Lanes' }
    let(:admin) do
      build :user, :admin, first_name: 'Dude', last_name: 'Lebowski'
    end
    let(:invitation) do
      UserInvitation.new({
        id: 42,
        first_name: 'Walter',
        last_name: 'Sobchak',
        email: 'walter@lebowski.me',
        inviting_user: admin,
        account: account
      })
    end
    let(:deliveries) do
      ActionMailer::Base.deliveries
    end
    let(:email) { deliveries.first }

    before do
      InvitationMailer.invitation_email(invitation).deliver_now
    end

    it 'sends an email' do
      expect(deliveries.size).to eq 1
    end

    it 'sends an email to the correct address' do
      expect(email.to).to eq ['walter@lebowski.me']
    end

    it 'sends an email from the correct address' do
      expect(email.from).to eq ['do-not-reply@evergreenmenus.com']
    end

    it 'sends an email with the correct subject' do
      expect(email.subject).to eq 'Invitation to Evergreen Menus'
    end

    it 'sends a multipart email' do
      expect(email.content_type).to include 'multipart/alternative'
    end

    it 'sends an email that includes a registration url' do
      expect(email.text_part.decoded).to match(%r{admin.evergreenmenus.locl/register/.+})
    end
  end
end
