require 'spec_helper'

module StripeEvent
  class TestEventHandler < Handler
  end

  describe Handler do
    describe '.handles' do
      it 'registers the class as a handler' do
        event = double type: 'test.event'
        TestEventHandler.handles 'test.event'
        expect(Handler.for(event)).to be_a TestEventHandler
      end
    end

    describe '.for' do
      let(:event) { double type: event_type }
      subject { Handler.for event }

      context 'when there is no handler registered for the given event' do
        let(:event_type) { 'foobar' }

        it { is_expected.to be_a NullHandler }

        it 'has a reference to the given event' do
          expect(subject.event).to eq event
        end
      end

      context 'when there is a handler registered for the given event' do
        let(:event_type) { 'test.event' }

        before { TestEventHandler.handles 'test.event' }

        it { is_expected.to be_a TestEventHandler }

        it 'has a reference to the given event' do
          expect(subject.event).to eq event
        end
      end
    end
  end
end
