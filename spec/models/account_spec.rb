require 'spec_helper'

describe Account do
  describe '#google_my_business_enabled?' do
    let(:account) { create(:account) }

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
end
