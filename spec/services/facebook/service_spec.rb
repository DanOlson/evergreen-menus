require 'spec_helper'

module Facebook
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

    describe '#pages' do
      let(:mock_client) { double(Client, pages: mock_pages_response) }

      context 'when the client request is successful' do
        let(:mock_pages_response) do
          double(Net::HTTPResponse, {
            code: '200',
            body: <<~JSON
              {
                "data": [
                  {
                    "access_token": "betty's-fake-access-token",
                    "category": "Restaurant",
                    "category_list": [
                      {
                        "id": "273819889375819",
                        "name": "Restaurant"
                      }
                    ],
                    "name": "Betty's Bakery",
                    "id": "240936686640816",
                    "perms": [
                      "ADMINISTER",
                      "EDIT_PROFILE",
                      "CREATE_CONTENT",
                      "MODERATE_CONTENT",
                      "CREATE_ADS",
                      "BASIC_ADMIN"
                    ]
                  }
                ],
                "paging": {
                  "cursors": {
                    "before": "MjQwOTM2Njg2NjQwODE2",
                    "after": "MjQwOTM2Njg2NjQwODE2"
                  }
                }
              }
            JSON
          })
        end

        it 'returns an array of page objects' do
          pages = instance.pages
          expect(pages).to be_an Array
          expect(pages.size).to eq 1
          expect(pages).to all satisfy { |i| i.is_a? Page }
        end

        it 'instantiates the pages correctly' do
          page = instance.pages.first
          expect(page.id).to eq '240936686640816'
          expect(page.name).to eq "Betty's Bakery"
          expect(page.access_token).to eq "betty's-fake-access-token"
        end
      end

      context 'when the client request is unauthorized' do
        let(:mock_pages_response) do
          double(Net::HTTPResponse, {
            code: '401',
            body: <<~JSON
              {
                "error": {
                  "message": "The access token is expired",
                  "type": "OAuthException",
                  "code": 190,
                  "fbtrace_id": "CjSDDB8tlAc"
                }
              }
            JSON
          })
        end

        it 'raises an UnauthorizedError' do
          expect {
            instance.pages
          }.to raise_error UnauthorizedError
        end
      end

      context 'when the client request is bad' do
        let(:mock_pages_response) do
          double(Net::HTTPResponse, {
            code: '400',
            body: <<~JSON
              {
                "error": {
                  "message": "An active access token must be used to query information about the current user.",
                  "type": "OAuthException",
                  "code": 2500,
                  "fbtrace_id": "HbkBOJGG6Nh"
                }
              }
            JSON
          })
        end

        it 'raises an error' do
          expect {
            instance.pages
          }.to raise_error StandardError
        end
      end
    end
  end
end
