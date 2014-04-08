require 'fast_spec_helper'

module Interactions
  describe ApiKey do
    let(:model){ double 'ApiKey' }
    let(:instance){ ApiKey.new }

    before do
      allow(instance).to receive(:model){ model }
    end

    describe '#create' do
      it 'creates an ApiKey' do
        allow(instance).to receive :generate_token
        expect(instance).to receive :generate_expiry
        expect(model).to receive :create
        instance.create
      end

      it 'generates an expiration date and a unique token' do
        expires_at = Time.now
        expect(instance).to receive(:generate_token){ 'foo' }
        expect(instance).to receive(:generate_expiry){ expires_at }
        expected = {
          access_token: 'foo',
          expires_at: expires_at,
          user_id: 1
        }
        expect(model).to receive(:create).with expected
        instance.create user_id: 1
      end
    end
  end
end
