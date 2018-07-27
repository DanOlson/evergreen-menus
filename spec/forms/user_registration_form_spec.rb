require 'spec_helper'

describe UserRegistrationForm do
  describe '#invitation' do
    context 'with an invitation object' do
      let(:instance) { UserRegistrationForm.from_invitation invitation }

      context 'with a UserInvitation' do
        let(:invitation) do
          create :user_invitation
        end

        it 'finds the correct record' do
          expect(instance.invitation).to eq invitation
        end
      end

      context 'with a SignupInvitation' do
        let(:invitation) do
          create :signup_invitation
        end

        it 'finds the correct record' do
          expect(instance.invitation).to eq invitation
        end
      end
    end

    context 'with type and id' do
      let(:instance) do
        UserRegistrationForm.new({
          invitation_type: type,
          invitation_id: id
        })
      end

      context 'with SignupInvitation' do
        let(:invitation) { create :signup_invitation }
        let(:type) { 'SignupInvitation' }
        let(:id) { invitation.id }

        it 'finds the correct record' do
          expect(instance.invitation).to eq invitation
        end
      end

      context 'with UserInvitation' do
        let(:invitation) { create :user_invitation }
        let(:type) { 'UserInvitation' }
        let(:id) { invitation.id }

        it 'finds the correct record' do
          expect(instance.invitation).to eq invitation
        end
      end

      context 'with an invalid type' do
        let(:invitation) { create :user_invitation }
        let(:account) { create :account }
        let(:type) { account.class.name }
        let(:id) { invitation.id }

        it 'returns nil' do
          expect(instance.invitation).to be_nil
        end
      end
    end
  end

  describe '#account' do
    let(:account) { create :account }
    let(:instance) { UserRegistrationForm.from_invitation invitation }

    context 'with a UserInvitation' do
      let(:invitation) do
        create :user_invitation, account: account
      end

      it 'finds the correct record' do
        expect(instance.account).to eq account
      end
    end

    context 'with a SignupInvitation' do
      let(:invitation) do
        create :signup_invitation, account: account
      end

      it 'finds the correct record' do
        expect(instance.account).to eq account
      end
    end
  end

  describe '#valid?' do
    subject { instance.valid?.tap { |res| puts instance.errors.full_messages unless res } }

    let(:instance) { UserRegistrationForm.new args }
    let(:args) do
      {
        first_name: 'Dan',
        last_name: 'Olson',
        username: 'olsondan@hotmail.com',
        email: 'olsondan@hotmail.com',
        password: '[FILTERED]',
        password_confirmation: '[FILTERED]',
        invitation_id: invitation.id,
        invitation_type: invitation.class.name
      }
    end

    context 'with a UserInvitation' do
      let(:invitation) { create :user_invitation }

      it { is_expected.to eq true }
    end

    context 'with a SignupInvitation' do
      let(:invitation) { create :signup_invitation }

      it { is_expected.to eq true }
    end
  end
end
