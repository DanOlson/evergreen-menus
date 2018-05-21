require 'spec_helper'

module GoogleMyBusiness
  describe Service do
    let(:instance) do
      Service.new(account: account, client: mock_client)
    end
    let(:mock_client) { double(Client) }
    let(:account) { build_stubbed :account }

    describe 'the default client' do
      it 'instantiates a client with the given account' do
        service = Service.new account: account
        expect(service.client.account).to eq account
      end
    end

    describe '#accounts' do
      let(:mock_client) { double(Client, accounts: mock_accounts_response) }

      context 'when the client request is successful' do
        let(:mock_accounts_response) do
          double(Net::HTTPResponse, {
            code: '200',
            body: <<~JSON
            {
              "accounts": [
                {
                  "name": "accounts/117056520034954462844",
                  "accountName": "Dan Olson",
                  "type": "PERSONAL",
                  "state": {
                    "status": "UNVERIFIED"
                  }
                },
                {
                  "name": "accounts/111337701469104826106",
                  "accountName": "Farbar Group",
                  "type": "LOCATION_GROUP",
                  "role": "OWNER",
                  "state": {
                    "status": "UNVERIFIED"
                  },
                  "permissionLevel": "OWNER_LEVEL"
                }
              ]
            }
            JSON
          })
        end

        it 'uses the client to get available accounts' do
          accounts = instance.accounts

          expect(accounts.size).to eq 2
          expect(accounts).to all satisfy { |a| a.is_a? Account }

          farbar = accounts[1]
          expect(farbar.name).to eq 'accounts/111337701469104826106'
          expect(farbar.account_name).to eq 'Farbar Group'
          expect(farbar.type).to eq 'LOCATION_GROUP'
          expect(farbar.role).to eq 'OWNER'
          expect(farbar.state).to eq({ 'status' => 'UNVERIFIED' })
          expect(farbar.permission_level).to eq 'OWNER_LEVEL'
        end
      end

      context 'when the client request is unauthorized' do
        let(:mock_accounts_response) do
          double(Net::HTTPResponse, {
            code: '401',
            body: <<~JSON
              {
                "error": {
                  "code": 401,
                  "message": "Request had invalid authentication credentials.",
                  "status": "UNAUTHENTICATED"
                }
              }
            JSON
          })
        end

        it 'returns an empty array' do
          expect(instance.accounts).to eq []
        end
      end
    end

    describe '#locations' do
      let(:mock_client) { double(Client, locations: locations_response) }
      let(:locations_response) do
        double(Net::HTTPResponse, {
          code: '200',
          body: <<~JSON
            {
              "locations": [
                {
                  "name": "accounts/111337701469104826106/locations/17679890243424107126",
                  "locationName": "Farbar",
                  "priceLists": []
                },
                {
                  "name": "accounts/111337701469104826106/locations/17679890243424107127",
                  "locationName": "Closepub",
                  "priceLists": []
                }
              ]
            }
          JSON
        })
      end

      context 'when the account is not associated to a GMB account' do
        it 'raises an error' do
          expect {
            instance.locations
          }.to raise_error(GoogleMyBusiness::MissingAccountAssociationException)
        end
      end

      context 'when the account is associated to a GMB account' do
        let(:account) { build_stubbed :account, google_my_business_account_id: 'account/12345' }

        it 'calls the client with the numeric portion of the account id' do
          instance.locations
          expect(mock_client).to have_received(:locations).with '12345'
        end

        context 'when the call to GMB API is successful' do
          it 'returns an array of Locations' do
            response = instance.locations
            expect(response.size).to eq 2
            expect(response).to all satisfy { |l| l.is_a? Location }

            loc1, loc2 = response
            expect(loc1.name).to eq 'accounts/111337701469104826106/locations/17679890243424107126'
            expect(loc1.location_name).to eq 'Farbar'

            expect(loc2.name).to eq 'accounts/111337701469104826106/locations/17679890243424107127'
            expect(loc2.location_name).to eq 'Closepub'
          end
        end

        context 'when the call to GMB API fails' do
          let(:locations_response) do
            double(Net::HTTPResponse, {
              code: '401',
              body: <<~JSON
                {
                  "error": {
                    "code": 401,
                    "message": "Request had invalid authentication credentials.",
                    "status": "UNAUTHENTICATED"
                  }
                }
              JSON
            })
          end

          it 'returns an empty array' do
            expect(instance.locations).to eq []
          end
        end
      end
    end

    describe '#location' do
      let(:mock_client) { double(Client, location: location_response) }
      let(:location_response) do
        double(Net::HTTPResponse, {
          code: '200',
          body: <<~JSON
            {
              "name": "accounts/111337701469104826106/locations/17679890243424107126",
              "locationName": "Farbar",
              "primaryCategory": {
                "displayName": "Restaurant",
                "categoryId": "gcid:restaurant"
              },
              "websiteUrl": "http://farbarmpls.com",
              "locationKey": {
                "requestId": "a03f8b54-d3fe-4b71-8af2-4a0fc4ef2ff5"
              },
              "latlng": {
                "latitude": 45.0401352,
                "longitude": -93.3152842
              },
              "openInfo": {
                "status": "OPEN",
                "canReopen": true
              },
              "locationState": {
                "canUpdate": true,
                "canDelete": true,
                "isDisconnected": true
              },
              "metadata": {},
              "languageCode": "en",
              "priceLists": [
                {
                  "priceListId": "Dinner",
                  "labels": [
                    {
                      "displayName": "Dinner"
                    }
                  ],
                  "sections": [
                    {
                      "sectionId": "pasta",
                      "labels": [
                        {
                          "displayName": "Pasta"
                        }
                      ],
                      "items": [
                        {
                          "itemId": "11559",
                          "labels": [
                            {
                              "displayName": "Chicken Florentine Pasta",
                              "description": "Pasta with spinach, tomato, artichoke, garlic, red onion, parmesan and mozzarella"
                            }
                          ],
                          "price": {
                            "currencyCode": "USD",
                            "units": "16"
                          }
                        },
                        {
                          "itemId": "11560",
                          "labels": [
                            {
                              "displayName": "Mushroom Fettuccine",
                              "description": "sautéed fresh garlic, mushrooms with sherry then tossed in mornay sauce, mixed with fettuccini pasta finished with bias cut asparagus tossed in lemon oil. Add Chicken or Shrimp upon request"
                            }
                          ],
                          "price": {
                            "currencyCode": "USD",
                            "units": "14"
                          }
                        },
                        {
                          "itemId": "11561",
                          "labels": [
                            {
                              "displayName": "Angel Hair Shrimp",
                              "description": "Large shrimp sautéed with lemon, garlic, herbs and fresh basil on top of angel hair pasta with a white wine sauce."
                            }
                          ],
                          "price": {
                            "currencyCode": "USD",
                            "units": "15"
                          }
                        }
                      ]
                    }
                  ]
                }
              ]
            }
          JSON
        })
      end

      context 'when the account is not associated to a GMB account' do
        it 'raises an error' do
          expect {
            instance.location('account/123/location/234')
          }.to raise_error(GoogleMyBusiness::MissingAccountAssociationException)
        end
      end

      context 'when the account is associated to a GMB account' do
        let(:account) { build_stubbed :account, google_my_business_account_id: 'account/12345' }

        it 'calls the client with the numeric portion of the account id' do
          instance.location 'account/12345/location/234'
          expect(mock_client).to have_received(:location).with '12345', '234'
        end

        context 'when the call to GMB API is successful' do
          it 'returns the Location' do
            location = instance.location('account/12345/location/98765')
            expect(location).to be_a Location

            expect(location.name).to eq 'accounts/111337701469104826106/locations/17679890243424107126'
            expect(location.location_name).to eq 'Farbar'
            expect(location.price_list).to_not be_nil
          end
        end

        context 'when the call to GMB API is unauthorized' do
          let(:location_response) do
            double(Net::HTTPResponse, {
              code: '401',
              body: <<~JSON
                {
                  "error": {
                    "code": 401,
                    "message": "Request had invalid authentication credentials.",
                    "status": "UNAUTHENTICATED"
                  }
                }
              JSON
            })
          end

          it 'raises a RequestFailedException' do
            expect {
              instance.location 'account/12345/location/234'
            }.to raise_error(GoogleMyBusiness::RequestFailedException)
          end

          it 'puts the response in the exception' do
            begin
              instance.location 'account/12345/location/234'
            rescue GoogleMyBusiness::RequestFailedException => e
              expect(e.response).to eq location_response
            end
          end
        end

        context 'when the call to GMB API is not found' do
          let(:location_response) do
            double(Net::HTTPResponse, {
              code: '404',
              body: <<~JSON
                {
                  "error": {
                    "code": 404,
                    "message": "Request entity was not found.",
                    "status": "NOT_FOUND"
                  }
                }
              JSON
            })
          end

          it 'raises a RequestFailedException' do
            expect {
              instance.location 'account/12345/location/234'
            }.to raise_error(GoogleMyBusiness::RequestFailedException)
          end

          it 'puts the response in the exception' do
            begin
              instance.location 'account/12345/location/234'
            rescue GoogleMyBusiness::RequestFailedException => e
              expect(e.response).to eq location_response
            end
          end
        end

        context 'when the given location_id is nil' do
          let(:location_id) { nil }

          it 'raises a RequestFailedException' do
            expect {
              instance.location location_id
            }.to raise_error(GoogleMyBusiness::RequestFailedException)
          end

          it 'reports 404' do
            begin
              instance.location location_id
            rescue => e
              expect(e.response.code).to eq '404'
              expect(e.message).to eq "location_id #{location_id} not found"
            end
          end
        end

        context 'when the given location_id is an empty string' do
          let(:location_id) { '' }

          it 'raises a RequestFailedException' do
            expect {
              instance.location location_id
            }.to raise_error(GoogleMyBusiness::RequestFailedException)
          end

          it 'reports 404' do
            begin
              instance.location location_id
            rescue => e
              expect(e.response.code).to eq '404'
              expect(e.message).to eq "location_id #{location_id} not found"
            end
          end
        end
      end
    end
  end
end
