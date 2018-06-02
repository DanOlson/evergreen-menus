require 'spec_helper'

describe 'contact form submission' do
  let(:params) do
    {
      contact: {
        name: 'Jeff Lebowski',
        email: 'dude@lebowski.me',
        message: 'Hey'
      }
    }
  end

  before do
    ActionMailer::Base.deliveries.clear
    post '/contact', {
      params: params,
      headers: { 'Origin' => origin }
    }
  end

  context 'when origin is evergreenmenus.com' do
    let(:origin) { 'https://evergreenmenus.com' }

    it 'redirects back to origin' do
      expect(response).to redirect_to "#{origin}?submitted=1"
    end

    it 'sends the correct CORS headers' do
      response_headers = response.headers
      expect(response_headers['access-control-allow-headers']).to eq 'Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token'
      expect(response_headers['access-control-allow-credentials']).to eq 'true'
      expect(response_headers['access-control-allow-origin']).to eq origin
      expect(response_headers['access-control-allow-methods']).to eq 'POST, OPTIONS'
    end

    it 'sends an email' do
      email = ActionMailer::Base.deliveries.last
      expect(email).to_not be_nil
      expect(email.subject).to eq '[Evergreen Menus] New Contact Form Submission'
    end

    context 'and the honeypot is present' do
      let(:params) do
        {
          contact: super()[:contact].merge(newsletter: '1')
        }
      end

      it 'redirects back to origin' do
        expect(response).to redirect_to "#{origin}?submitted=1"
      end

      it 'sends the correct CORS headers' do
        response_headers = response.headers
        expect(response_headers['access-control-allow-headers']).to eq 'Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token'
        expect(response_headers['access-control-allow-credentials']).to eq 'true'
        expect(response_headers['access-control-allow-origin']).to eq origin
        expect(response_headers['access-control-allow-methods']).to eq 'POST, OPTIONS'
      end

      it 'does not send an email' do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end

  context 'when origin is not evergreenmenus.com' do
    let(:origin) { 'https://everbluemenus.com' }

    it 'returns 401' do
      expect(response).to have_http_status :unauthorized
    end

    it 'does not send an email' do
      expect(ActionMailer::Base.deliveries).to be_empty
    end
  end
end
