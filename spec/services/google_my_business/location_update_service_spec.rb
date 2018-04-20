require 'spec_helper'

module GoogleMyBusiness
  describe LocationUpdateService do
    describe '#menu_serializer' do
      let(:account) { build_stubbed :account }
      let(:establishment) { build_stubbed :establishment, account: account }

      it 'has a valid default' do
        instance = LocationUpdateService.new establishment: establishment
        expect(instance.menu_serializer).to be_a GoogleMyBusiness::WebMenuSerializer
      end
    end

    describe '#api_client' do
      let(:account) { build_stubbed :account }
      let(:establishment) { build_stubbed :establishment, account: account }

      it 'has a valid default' do
        instance = LocationUpdateService.new establishment: establishment
        expect(instance.api_client).to be_a GoogleMyBusiness::Client
        expect(instance.api_client.account).to eq account
      end
    end

    describe '#call' do
      let(:establishment) { create :establishment, google_my_business_location_id: 'accounts/asdf/locations/1234' }
      let!(:lunch_menu) do
        create :web_menu, {
          name: 'Lunch',
          establishment: establishment,
          sync_to_google: true
        }
      end
      let!(:dinner_menu) do
        create :web_menu, {
          name: 'Dinner',
          establishment: establishment,
          sync_to_google: true
        }
      end
      let!(:happy_hour_menu) do
        create :web_menu, {
          name: 'Happy Hour',
          establishment: establishment,
          sync_to_google: false
        }
      end
      let(:mock_client) { double('Client', update_location: nil) }
      let(:mock_menu_serializer) { double('WebMenuSerializer', call: nil) }
      let(:instance) do
        LocationUpdateService.new(
          establishment: establishment,
          menu_serializer: mock_menu_serializer,
          api_client: mock_client
        )
      end

      it 'serializes the menus flagged as synced to Google' do
        instance.call
        expect(mock_menu_serializer).to have_received(:call).with lunch_menu
        expect(mock_menu_serializer).to have_received(:call).with dinner_menu
        expect(mock_menu_serializer).to_not have_received(:call).with happy_hour_menu
      end

      it 'calls the client with the expected parameters' do
        ###
        # Stub the serializer to simply return the menu name
        allow(mock_menu_serializer).to receive(:call) { |menu| menu.name }
        expected = {
          account_id: 'asdf',
          location_id: '1234',
          body: { priceLists: ['Lunch', 'Dinner'] }
        }

        instance.call

        expect(mock_client).to have_received(:update_location).with expected
      end
    end
  end
end
