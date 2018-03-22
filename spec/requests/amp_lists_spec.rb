require 'spec_helper'

describe 'getting data for amp-list' do
  let(:establishment) do
    create :establishment, url: 'https://farbarmpls.com'
  end
  let(:list) do
    create :list, :with_items, item_count: 4, establishment: establishment
  end

  describe 'GET to /amp/list/:id' do
    context 'same-origin request' do
      let(:headers) do
        {
          'AMP-Same-Origin' => 'true',
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
    end

    context 'AMP cache cross-origin request' do
      let(:headers) do
        {
          'origin' => 'https://farbarmpls-com.cdn.ampproject.org',
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
        expect(response_headers['access-control-allow-origin']).to eq 'https://farbarmpls-com.cdn.ampproject.org'
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
  end
end
