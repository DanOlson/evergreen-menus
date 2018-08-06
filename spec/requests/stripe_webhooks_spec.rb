require 'spec_helper'

describe 'Stripe webhooks' do
  before do
    test_wh_secret = 'whsec_7WHiEYgrlGYN1OjTWm3ABBdLouCPiifk'
    allow(ENV).to receive(:fetch).with('STRIPE_WEBHOOK_SECRET') { test_wh_secret }
    # Timestamp must be within the tolerance zone
    Timecop.freeze Time.parse '2018-08-05 17:30:02 -0500'
  end

  after do
    Timecop.return
  end

  describe 'POST to /stripe/events' do
    let(:req_body) do
      File.read(Rails.root.join('spec', 'support', 'webhooks', 'plan.created.json'))
    end

    before do
      post '/stripe/events', {
        headers: {
          'Stripe-Signature' => sig,
          'Content-Type' => 'application/json; charset=utf-8',
          'Accept' => '*/*; q=0.5, application/xml'
        },
        params: req_body
      }
    end

    context 'with a valid signature' do
      let(:sig) do
        [
          't=1533510366',
          'v1=2cb170dd90a0659f057f58acc729783f4b9277f71aea7eacd4ec9db3211432c8',
          'v0=5b59e766a642a4d9ba6ba10ad677edbe32e0f5970f0a4b2da87f6d647df58caa'
        ].join(',')
      end

      it 'succeeds' do
        expect(response).to have_http_status :ok
      end
    end

    context 'without a valid signature' do
      let(:sig) do
        [
          't=1532743333',
          'v1=73eac8bd9ca3cbc77c3f1f2682d7df28dbe4c26942c5984b8d20e61342b3a806',
          'v0=fb7634169ba55d5c928e3032bbf3ac9e2c2e14a40e5414ca3666abb08fd8a3cd'
        ].join(',')
      end

      it 'returns 400' do
        expect(response).to have_http_status :bad_request
      end
    end
  end
end
