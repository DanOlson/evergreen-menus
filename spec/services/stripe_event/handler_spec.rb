require 'spec_helper'

module StripeEvent
  describe Handler do
    describe '.handles' do
      class TestEventHandler < Handler
        handles 'test.event'
      end

      it 'registers the class as a handler' do
        expect(Handler.for('test.event')).to eq TestEventHandler
      end
    end
  end
end
