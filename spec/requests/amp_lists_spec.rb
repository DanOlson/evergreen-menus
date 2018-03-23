require 'spec_helper'

describe 'CORS behavior around getting data for amp-list' do
  let(:establishment) do
    create :establishment, url: 'https://farbarmpls.com'
  end
  let(:list) do
    create :list, :with_items, item_count: 4, establishment: establishment
  end

  shared_examples 'AMP cache cross-origin request' do
    let(:headers) do
      {
        'origin' => origin,
        'Content-Type' => 'application/json'
      }
    end

    before do
      get "/amp/lists/#{list.id}.json?__amp_source_origin=https%3A%2F%2Ffarbarmpls.com", headers: headers
    end

    it 'sends the correct CORS response headers' do
      expect(response).to have_http_status(:ok)
      response_headers = response.headers
      expect(response_headers['access-control-allow-headers']).to eq 'Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token'
      expect(response_headers['access-control-allow-credentials']).to eq 'true'
      expect(response_headers['access-control-allow-origin']).to eq origin
      expect(response_headers['amp-access-control-allow-source-origin']).to eq 'https://farbarmpls.com'
      expect(response_headers['access-control-allow-methods']).to eq 'GET, OPTIONS'
      expect(response_headers['access-control-expose-headers']). to eq 'AMP-Access-Control-Allow-Source-Origin'
    end

    it 'returns the list items' do
      parsed = JSON.parse(response.body)
      expect(parsed['items'].size).to eq 4
      expect(parsed['items']).to all satisfy { |item|
        item.key?('name') && item.key?('description') && item.key?('price')
      }
    end
  end

  shared_examples 'an unauthorized request' do
    it 'is unauthorized' do
      expect(response).to have_http_status(:unauthorized)
      expect(response.content_type).to eq 'application/json'
      expect(JSON.parse(response.body)['message']).to eq 'Unauthorized'
    end
  end

  describe 'GET to /amp/list/:id' do
    context 'same-origin request' do
      let(:headers) do
        {
          'AMP-Same-Origin' => 'true',
          'Content-Type' => 'application/json'
        }
      end

      context 'when the requested list exists' do
        before do
          get "/amp/lists/#{list.id}.json?__amp_source_origin=https%3A%2F%2Ffarbarmpls.com", headers: headers
        end

        it 'sends the correct CORS response headers' do
          expect(response).to have_http_status(:ok)
          response_headers = response.headers
          expect(response_headers['access-control-allow-headers']).to eq 'Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token'
          expect(response_headers['access-control-allow-credentials']).to eq 'true'
          expect(response_headers['access-control-allow-origin']).to eq 'https://farbarmpls.com'
          expect(response_headers['amp-access-control-allow-source-origin']).to eq 'https://farbarmpls.com'
          expect(response_headers['access-control-allow-methods']).to eq 'GET, OPTIONS'
          expect(response_headers['access-control-expose-headers']). to eq 'AMP-Access-Control-Allow-Source-Origin'
        end

        it 'returns the list items' do
          parsed = JSON.parse(response.body)
          expect(parsed['items'].size).to eq 4
          expect(parsed['items']).to all satisfy { |item|
            item.key?('name') && item.key?('description') && item.key?('price')
          }
        end

        context 'when __amp_source_origin does not match establishment URL' do
          before do
            get "/amp/lists/#{list.id}.json?__amp_source_origin=https%3A%2F%2Fclosebarmpls.com", headers: headers
          end

          it_behaves_like 'an unauthorized request'
        end

        context "when the establishment's account is inactive" do
          before do
            account = establishment.account
            account.update(active: false)
            get "/amp/lists/#{list.id}.json?__amp_source_origin=https%3A%2F%2Ffarbarmpls.com", headers: headers
          end

          it_behaves_like 'an unauthorized request'
        end
      end

      context 'when the requested list is not found' do
        let(:list_id) { 509 }

        before do
          get "/amp/lists/#{list_id}.json?__amp_source_origin=https%3A%2F%2Ffarbarmpls.com", headers: headers
        end

        it 'returns 404' do
          expect(response).to have_http_status :not_found
          expect(response.content_type).to eq 'application/json'
        end
      end
    end

    context 'cross-origin request' do
      context 'when the origin header is from https://farbarmpls-com.cdn.ampproject.org' do
        let(:origin) { 'https://farbarmpls-com.cdn.ampproject.org' }

        it_behaves_like 'AMP cache cross-origin request'
      end

      context 'when the origin header is from https://cdn.ampproject.org' do
        let(:origin) { 'https://cdn.ampproject.org' }

        it_behaves_like 'AMP cache cross-origin request'
      end

      context 'when the origin header is from amp.cloudflare.com' do
        let(:origin) { 'https://farbarmpls.com.amp.cloudflare.com' }

        it_behaves_like 'AMP cache cross-origin request'
      end

      context 'when the origin header is from the establishment URL' do
        let(:origin) { 'https://farbarmpls.com' }

        it_behaves_like 'AMP cache cross-origin request'
      end

      context 'when the origin header is anything else' do
        let(:headers) do
          {
            'origin' => 'https://www.google.com',
            'Content-Type' => 'application/json'
          }
        end

        before do
          get "/amp/lists/#{list.id}.json?__amp_source_origin=https%3A%2F%2Ffarbarmpls.com", headers: headers
        end

        it_behaves_like 'an unauthorized request'
      end
    end
  end
end
