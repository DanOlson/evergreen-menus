require 'spec_helper'

describe 'Stripe webhooks' do
  before do
    allow(ENV).to receive(:fetch).with('STRIPE_WEBHOOK_SECRET') { 'whsec_7WHiEYgrlGYN1OjTWm3ABBdLouCPiifk' }
    # Timecop.freeze(Time.at(1532746749))
    Timecop.freeze Time.parse '2018-07-29 08:17:52 -0500'
  end

  after do
    Timecop.return
  end

  describe 'POST to /stripe/events' do
    let(:req_body) do
      File.read(Rails.root.join('spec', 'support', 'webhooks', 'invoice.payment_succeeded.json'))
    end

    before do
      post '/stripe/events', {
        headers: {
          'Stripe-Signature' => sig,
          'Content-Type' => 'application/json; charset=utf-8',
          'Accept' => '*/*; q=0.5, application/xml'
        },
        params: JSON.parse(req_body)
      }
    end

    context 'with a valid signature' do
      let(:sig) do
        [
          't=1532870271',
          'v1=d9b63f485cb2a20f00bee0c2f608728aedd97d048a1cffd3a6d035b8d69ba3d4',
          'v0=5cf063bd7a6db14bbdc59ca71e49f638a00735cfcd5d6533283aac47c4be97ed'
        ].join(',')
      end

      xit 'succeeds' do
        ###
        # This is working via Stripe's web interface + ngrok. I've copied the +exact+
        # request into this test multiple times with no luck.
        # No signatures found matching the expected signature for payload
        #
        # I think I need to register an encoder with Actionpack so that I can
        # send the right content-type/accept headers, but pass the body as a
        # JSON string, rather than a Ruby Hash of params.
        #
        # https://stripe.com/docs/webhooks/signatures
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
