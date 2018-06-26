require 'spec_helper'

module GoogleMyBusiness
  describe LocationUpdateService do
    describe '#menu_serializer' do
      let(:account) { build_stubbed :account }
      let(:establishment) { build_stubbed :establishment, account: account }

      it 'has a valid default' do
        instance = LocationUpdateService.new establishment: establishment
        expect(instance.menu_serializer).to be_a GoogleMyBusiness::MenuSerializer
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
      let!(:online_menu) do
        create :online_menu, establishment: establishment
      end
      let(:mock_client) { double('Client', update_location: nil) }
      let(:mock_menu_serializer) { double('MenuSerializer', call: nil) }
      let(:instance) do
        LocationUpdateService.new(
          establishment: establishment,
          menu_serializer: mock_menu_serializer,
          api_client: mock_client
        )
      end

      shared_examples_for 'noop' do
        it 'does not serialize the menus' do
          instance.call
          expect(mock_menu_serializer).to_not have_received(:call)
        end

        it 'does not call the client' do
          instance.call

          expect(mock_client).to_not have_received(:update_location)
        end
      end

      context 'when there is an auth token for the account' do
        before do
          AuthToken.google.for_account(account).create!({
            token_data: '{"access_token":"foo","refresh_token":"bar"}',
            access_token: 'foo',
            refresh_token: 'bar'
          })
        end

        context 'and the account has a google_my_business_account_id ' do
          let(:account) { create :account, google_my_business_account_id: 'asdf' }

          context 'and the establishment has a google_my_business_location_id' do
            let(:establishment) { create :establishment, account: account, google_my_business_location_id: 'accounts/asdf/locations/1234' }

            it 'serializes the Online Menu' do
              instance.call
              expect(mock_menu_serializer).to have_received(:call).with online_menu
            end

            it 'calls the client with the expected parameters' do
              ###
              # Stub the serializer to simply return the menu name
              allow(mock_menu_serializer).to receive(:call) { |menu| menu.name }
              expected = {
                account_id: 'asdf',
                location_id: '1234',
                body: { priceLists: ['Online Menu'] }
              }

              instance.call

              expect(mock_client).to have_received(:update_location).with expected
            end
          end

          context 'and the establishment does not have a google_my_business_location_id' do
            let(:establishment) { create :establishment, account: account, google_my_business_location_id: nil }

            it_behaves_like 'noop'
          end

          context 'and the establishment has an empty google_my_business_location_id' do
            let(:establishment) { create :establishment, account: account, google_my_business_location_id: '' }

            it_behaves_like 'noop'
          end
        end

        context 'and the account does not have a google_my_business_account_id' do
          let(:account) { create :account, google_my_business_account_id: nil }
          let(:establishment) { create :establishment, account: account, google_my_business_location_id: 'accounts/asdf/locations/1234' }

          it_behaves_like 'noop'
        end
      end

      context 'when there is not an auth token for the account' do
        let(:account) { create :account, google_my_business_account_id: 'asdf' }
        let(:establishment) { create :establishment, account: account, google_my_business_location_id: 'accounts/asdf/locations/1234' }

        it_behaves_like 'noop'
      end
    end
  end
end
