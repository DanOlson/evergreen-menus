require 'spec_helper'

describe Account do
  describe 'deleting' do
    let(:account) { create :account }

    context 'when the account has an establishment' do
      before do
        create :establishment, account: account
      end

      it 'can be deleted' do
        expect {
          account.destroy
        }.to change(Account, :count).by(-1)
          .and change(Establishment, :count).by(-1)
      end
    end

    context 'when the account has a user' do
      before do
        create :user, :account_admin, account: account
      end

      it 'can be deleted' do
        expect {
          account.destroy
        }.to change(Account, :count).by(-1)
          .and change(User, :count).by(-1)
      end
    end

    context 'when the account has a user_invitation' do
      before do
        create :user_invitation, account: account
      end

      it 'can be deleted' do
        expect {
          account.destroy
        }.to change(Account, :count).by(-1)
          .and change(UserInvitation, :count).by(-1)
      end
    end

    context 'when the account has a payment' do
      before do
        Payment.create! account: account
      end

      it 'can be deleted' do
        expect {
          account.destroy
        }.to change(Account, :count).by(-1)
          .and change(Payment, :count).by(-1)
      end
    end

    context 'when the account has a subscription' do
      before do
        plan = create :plan, :tier_1
        Subscription.create! account: account, plan: plan, remote_id: '123'
      end

      it 'can be deleted' do
        expect {
          account.destroy
        }.to change(Account, :count).by(-1)
          .and change(Subscription, :count).by(-1)
          .and change(Plan, :count).by(0)
      end
    end

    context 'when the account has a signup_invitation' do
      before do
        user = create :user, :account_admin, account: account
        SignupInvitation.create!({
          account: account,
          role: Role.account_admin,
          accepting_user: user
        })
      end

      it 'can be deleted' do
        expect {
          account.destroy
        }.to change(Account, :count).by(-1)
          .and change(SignupInvitation, :count).by(-1)
          .and change(User, :count).by(-1)
          .and change(Role, :count).by(0)
      end
    end
  end

  describe '#google_my_business_enabled?' do
    let(:account) { create :account }

    subject { account.google_my_business_enabled? }

    context 'when there is a Google auth token' do
      before do
        now = Time.now
        AuthToken.google.for_account(account).create!({
          token_data: { "access_token" => "a-mock-access-token", "refresh_token" => "the-mock-refresh-token" },
          access_token: 'a-mock-access-token',
          refresh_token: 'the-mock-refresh-token',
          expires_at: now + 3600.seconds
        })
      end

      it { is_expected.to eq true }
    end

    context 'when there is not a Google auth token' do
      it { is_expected.to eq false }
    end
  end

  describe '#facebook_enabled?' do
    let(:account) { create :account }

    subject { account.facebook_enabled? }

    context 'when there is a Facebook user auth token' do
      before do
        now = Time.now
        AuthToken.facebook_user.for_account(account).create!({
          token_data: { "access_token" => "a-mock-access-token" },
          access_token: 'a-mock-access-token',
          expires_at: now + 3600.seconds
        })
      end

      it { is_expected.to eq true }
    end

    context 'when there is not a Facebook user auth token' do
      it { is_expected.to eq false }
    end
  end

  describe 'google_my_business_account_id' do
    it 'enforces uniqueness' do
      account1 = create :account, google_my_business_account_id: 'foo'
      account2 = build :account

      expect(account1).to be_valid
      expect(account2).to be_valid

      account2.google_my_business_account_id = 'foo'
      expect(account2).to_not be_valid
      expect(account2.errors[:google_my_business_account_id]).to eq ['has already been taken']
    end

    it 'allows null' do
      account1 = create :account, google_my_business_account_id: nil
      account2 = build :account, google_my_business_account_id: nil

      expect(account1).to be_valid
      expect(account2).to be_valid
    end
  end
end
