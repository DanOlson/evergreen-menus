require 'spec_helper'

describe User do
  describe 'establishment assignments' do
    let(:account) { create :account }
    let(:user) { create :user, account: account }

    context "to establishments under the user's account" do
      let!(:establishment_1) { create :establishment, account: account }
      let!(:establishment_2) { create :establishment, account: account }

      it 'returns the correct establishments' do
        expect(user.establishments).to be_empty

        user.establishments << establishment_1
        expect(user.establishments.size).to eq 1
        expect(user.establishments).to include establishment_1
        expect(user.establishments).to_not include establishment_2
      end
    end

    context "to establishments under a different account" do
      let(:other_account) { create :account }
      let(:establishment) { create :establishment, account: other_account }

      it 'is not possible' do
        expect(user.establishments).to be_empty
        expect {
          user.establishments << establishment
        }.to raise_error ActiveRecord::RecordInvalid
      end
    end
  end
end
