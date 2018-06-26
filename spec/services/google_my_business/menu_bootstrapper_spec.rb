require 'spec_helper'

module GoogleMyBusiness
  describe MenuBootstrapper do
    let(:location_id) { '/accounts/123/locations/456' }
    let(:establishment) do
      create :establishment, google_my_business_location_id: location_id
    end
    let(:logger) { double 'Logger', error: nil, info: nil }

    describe 'initialization' do
      it 'uses a correctly configured Service by default' do
        instance = MenuBootstrapper.new(
          establishment: establishment,
          gmb_location_id: location_id
        )
        service = instance.gmb_service
        expect(service).to be_a Service
        expect(service.account).to eq establishment.account
      end
    end

    describe '#call' do
      let(:mock_gmb_service) do
        double Service
      end
      let(:instance) do
        MenuBootstrapper.new(
          establishment: establishment,
          gmb_location_id: location_id,
          gmb_service: mock_gmb_service,
          logger: logger
        )
      end

      context 'when the GMB location with priceList already exists' do
        let(:price_list) do
          {
            "priceListId" => "Dinner",
            "labels" => [
              {
                "displayName" => "Dinner"
              }
            ],
            "sections" => [
              {
                "sectionId" => "pasta",
                "labels" => [
                  {
                    "displayName" => "Pasta"
                  }
                ],
                "items" => [
                  {
                    "itemId" => "11559",
                    "labels" => [
                      {
                        "displayName" => "Chicken Florentine Pasta",
                        "description" => "Pasta with spinach, tomato, artichoke, garlic, red onion, parmesan and mozzarella"
                      }
                    ],
                    "price" => {
                      "currencyCode" => "USD",
                      "units" => "16",
                      "nanos" => 250000000
                    }
                  },
                  {
                    "itemId" => "11341",
                    "labels" => [
                      {
                        "displayName" => "Macaroni and Cheese",
                        "description" => "Classic homemade mac and cheese topped with breadcrumbs"
                      }
                    ],
                    "price" => {
                      "currencyCode" => "USD",
                      "units" => "9"
                    }
                  }
                ]
              }
            ]
          }
        end

        before do
          allow(mock_gmb_service).to receive(:location).with(location_id) do
            Location.new({ 'priceLists' => [price_list] })
          end
        end

        context 'and an OnlineMenu does not yet exist for the establishment' do
          before do
            expect(establishment.online_menu).to eq nil
          end

          it 'creates a OnlineMenu' do
            expect {
              instance.call
            }.to change(OnlineMenu, :count).by 1

            expect(establishment.online_menu).to_not eq nil
            expect(establishment.online_menu.name).to eq 'Dinner'
          end

          it 'creates the correct lists' do
            instance.call
            menu = establishment.online_menu
            lists = menu.lists.all
            expect(lists.size).to eq 1
            expect(lists.first.name).to eq 'Pasta'
            expect(lists.first.show_price_on_menu).to eq true
            expect(lists.first.show_description_on_menu).to eq true
          end

          it 'creates the correct list items' do
            instance.call
            list = establishment.online_menu.lists.first
            expect(list.beers.size).to eq 2

            florentine, mac_and_cheese = list.beers
            expect(florentine.name).to eq 'Chicken Florentine Pasta'
            expect(florentine.description).to eq 'Pasta with spinach, tomato, artichoke, garlic, red onion, parmesan and mozzarella'
            expect(florentine.price).to eq 16.25

            expect(mac_and_cheese.name).to eq 'Macaroni and Cheese'
            expect(mac_and_cheese.description).to eq 'Classic homemade mac and cheese topped with breadcrumbs'
            expect(mac_and_cheese.price).to eq 9
          end

          context 'but one of the lists on the GMB location already exists' do
            before do
              pasta = create(:list, name: 'Pasta', establishment: establishment)
              create(:menu_item, name: 'Spaghetti', price: '8', description: 'Basic Spaghetti', list: pasta)
              create(:menu_item, name: 'Ravioli', price: '8', description: 'Basic Ravioli', list: pasta)
              expect(pasta.beers.size).to eq 2
            end

            it 'does not change the existing list' do
              instance.call
              list = establishment.online_menu.lists.first
              expect(list.beers.size).to eq 2

              spaghetti, ravoili = list.beers
              expect(spaghetti.name).to eq 'Spaghetti'
              expect(spaghetti.description).to eq 'Basic Spaghetti'
              expect(spaghetti.price).to eq 8

              expect(ravoili.name).to eq 'Ravioli'
              expect(ravoili.description).to eq 'Basic Ravioli'
              expect(ravoili.price).to eq 8
            end
          end
        end

        context 'and an OnlineMenu already exists for the establishment' do
          before do
            create :online_menu, name: 'Menu', establishment: establishment
          end

          it 'does not create a new OnlineMenu' do
            expect {
              instance.call
            }.to_not change(OnlineMenu, :count)
          end

          it 'updates the existing OnlineMenu' do
            instance.call
            menu = establishment.online_menu
            expect(menu.name).to eq 'Dinner'
            lists = menu.lists.all
            expect(lists.size).to eq 1
            expect(lists.first.name).to eq 'Pasta'
            list = establishment.online_menu.lists.first
            expect(list.beers.size).to eq 2

            florentine, mac_and_cheese = list.beers
            expect(florentine.name).to eq 'Chicken Florentine Pasta'
            expect(florentine.description).to eq 'Pasta with spinach, tomato, artichoke, garlic, red onion, parmesan and mozzarella'
            expect(florentine.price).to eq 16.25

            expect(mac_and_cheese.name).to eq 'Macaroni and Cheese'
            expect(mac_and_cheese.description).to eq 'Classic homemade mac and cheese topped with breadcrumbs'
            expect(mac_and_cheese.price).to eq 9
          end
        end
      end

      context 'when the GMB location does not yet have a priceList' do
        before do
          allow(mock_gmb_service).to receive(:location).with(location_id) do
            Location.new({
              'name' => '/accounts/123/locations/456',
              'locationName' => 'My Location'
            })
          end
        end

        it 'creates an OnlineMenu with no lists' do
          expect {
            instance.call
          }.to change(OnlineMenu, :count).by 1

          menu = establishment.online_menu
          expect(menu).to_not eq nil
          expect(menu.name).to eq 'Menu'
          expect(menu.lists.all.size).to eq 0
        end
      end

      context 'when the request to get the location fails' do
        let(:location_response) do
          double(Net::HTTPResponse, {
            code: '401',
            body: <<~JSON
              {
                "error": {
                  "code": 401,
                  "message": "Request had invalid authentication credentials.",
                  "status": "UNAUTHORIZED"
                }
              }
            JSON
          })
        end

        before do
          allow(mock_gmb_service).to receive(:location).with(location_id) do
            raise GoogleMyBusiness::RequestFailedException.new location_response
          end
        end

        it 'does not create an OnlineMenu' do
          expect {
            instance.call
          }.to change(OnlineMenu, :count).by 0
          expect(establishment.online_menu).to eq nil
        end

        it 'logs the error' do
          instance.call
          expect(logger).to have_received(:error).with 'Google My Business Location request failed with status: 401'
          expect(logger).to have_received(:error).with 'Request had invalid authentication credentials.'
        end
      end
    end
  end
end
