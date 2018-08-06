require 'spec_helper'

module StripeEvent
  describe NullHandler do
    let(:instance) { NullHandler.new(event, logger: logger) }
    let(:logger) { double 'FakeLogger', info: nil }
    let(:event_data) do
      JSON.parse(
        IO.read(
          Rails.root.join('spec', 'support', 'webhooks', 'plan.created.json')
        ), symbolize_names: true
      )
    end
    let(:event) { Stripe::Event.construct_from event_data }

    describe '#call' do
      it 'logs the event' do
        expected_message = 'Received Stripe event "plan.created" with id "evt_00000000000000"'
        instance.call
        expect(logger).to have_received(:info).with expected_message
      end
    end
  end
end
