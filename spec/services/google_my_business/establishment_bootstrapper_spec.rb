require 'spec_helper'

module GoogleMyBusiness
  describe EstablishmentBootstrapper do
    let(:account) { create :account }
    let(:establishment) do
      create :establishment, {
        account: account,
        google_my_business_location_id: 'accounts/123/locations/456'
      }
    end
    let(:instance) { EstablishmentBootstrapper.new account }

    describe '#bootstrap_menus' do
      it "calls a MenuBootstrapper for each of the account's establishments" do
        expect(MenuBootstrapper).to receive(:call).with({
          establishment: establishment,
          gmb_location_id: 'accounts/123/locations/456'
        })
        instance.bootstrap_menus
      end
    end

    describe '#purge_menus' do
      let(:establishment2) do
        create :establishment, {
          account: account,
          google_my_business_location_id: 'accounts/123/locations/234'
        }
      end

      context 'when there are establishments with menus' do
        before do
          create(:google_menu, name: 'Menu1', establishment: establishment)
          create(:google_menu, name: 'Menu2', establishment: establishment2)
          expect(establishment.google_menu).to_not be_nil
          expect(establishment2.google_menu).to_not be_nil
        end

        it 'deletes the menus' do
          expect {
            instance.purge_menus
          }.to change(GoogleMenu, :count).by -2
          expect(establishment.reload.google_menu).to eq nil
          expect(establishment2.reload.google_menu).to eq nil
        end
      end

      context 'when there are no establishments with menus' do
        it 'deletes no menus' do
          expect {
            instance.purge_menus
          }.to_not change(GoogleMenu, :count)
        end
      end
    end
  end
end
