require 'spec_helper'

module GoogleMyBusiness
  describe EstablishmentBootstrapper do
    let(:account) { establishment.account }
    let(:establishment) { create :establishment, google_my_business_location_id: 'accounts/123/locations/456' }

    describe '#bootstrap_menus' do
      it "calls a MenuBootstrapper for each of the account's establishments" do
        expect(MenuBootstrapper).to receive(:call).with({
          establishment: establishment,
          gmb_location_id: 'accounts/123/locations/456'
        })
        instance = EstablishmentBootstrapper.new account
        instance.bootstrap_menus
      end
    end
  end
end
