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

    describe '#page_access_token' do
      let(:mock_client) { double(Client, page: mock_page_response) }
      let(:establishment) do
        build_stubbed :establishment, {
          account: account,
          facebook_page_id: '240936686640816'
        }
      end

      context 'with a successful response from the client' do
        let(:mock_page_response) do
          double(Net::HTTPResponse, {
            code: '200',
            body: <<~JSON
              {
                "access_token": "a-fake-access-token",
                "id": "240936686640816"
              }
            JSON
          })
        end

        it 'returns the token value' do
          expect(instance.page_access_token(establishment)).to eq 'a-fake-access-token'
        end
      end

      context 'with an unauthorized response from the client' do
        let(:mock_page_response) do
          double(Net::HTTPResponse, {
            code: '401',
            body: <<~JSON
              {
                "error": {
                  "message": "Error validating access token: This may be because the user logged out or may be due to a system error.",
                  "type": "OAuthException",
                  "code": 190,
                  "error_subcode": 467,
                  "fbtrace_id": "EVhvn+0BHWK"
                }
              }
            JSON
          })
        end

        it 'raises an UnauthorizedError' do
          expect {
            instance.page_access_token establishment
          }.to raise_error UnauthorizedError
        end
      end

      context 'with an unsuccessful response from the client' do
        let(:mock_page_response) do
          double(Net::HTTPResponse, {
            code: '500',
            body: <<~JSON
              {
                "error": {
                  "message": "Internal server error",
                  "type": "BadException",
                  "code": 199,
                  "error_subcode": 467,
                  "fbtrace_id": "EVhvn+0BHWK"
                }
              }
            JSON
          })
        end

        it 'raises an error' do
          expect {
            instance.page_access_token establishment
          }.to raise_error RuntimeError
        end
      end
    end

    describe '#create_tab' do
      let(:mock_client) { double(Client) }
      let(:establishment) do
        build_stubbed :establishment, account: account
      end

      before do
        expect(mock_client)
          .to receive(:create_tab)
          .with(establishment)
          .and_return create_tab_response
      end

      context 'when the request is successful' do
        let(:create_tab_response) do
          double(Net::HTTPResponse, {
            code: '201',
            body: <<~JSON
              { "id": "aSdf" }
            JSON
          })
        end

        it 'returns nil' do
          result = instance.create_tab establishment
          expect(result).to eq nil
        end
      end

      context 'when the request is forbidden' do
        let(:create_tab_response) do
          double(Net::HTTPResponse, {
            code: '403',
            body: <<~JSON
              {
                "error": {
                  "message": "(#210) A page access token is required to request this resource.",
                  "type": "OAuthException",
                  "code": 210,
                  "fbtrace_id": "HvuKEzoI+w9"
                }
              }
            JSON
          })
        end

        it 'raises an error' do
          expect {
            instance.create_tab establishment
          }.to raise_error RuntimeError, "(#210) A page access token is required to request this resource."
        end
      end

      context 'when the request is bad' do
        let(:create_tab_response) do
          double(Net::HTTPResponse, {
            code: '400',
            body: <<~JSON
              {
                "error": {
                  "message": "(#2069016) This page does not have permission to install the custom tab",
                  "type": "OAuthException",
                  "code": 2069016,
                  "fbtrace_id": "Bb+NGCFyYrq"
                }
              }
            JSON
          })
        end

        it 'raises an error' do
          expect {
            instance.create_tab establishment
          }.to raise_error RuntimeError, "(#2069016) This page does not have permission to install the custom tab"
        end
      end
    end
  end
end
