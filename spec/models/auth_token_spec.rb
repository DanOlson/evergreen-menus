require 'spec_helper'

describe AuthToken do
  describe '#expired?' do
    let(:instance) do
      AuthToken.new(
        expires_at: expires_at
      )
    end

    subject { instance.expired? }

    context 'when +expires_at+ is in the future' do
      let(:expires_at) { Time.now + 1.second }

      it { is_expected.to eq false }
    end

    context 'when +expires_at+ is in the past' do
      let(:expires_at) { Time.now - 1.second }

      it { is_expected.to eq true }
    end

    context 'when +expires_at+ is right now' do
      let(:expires_at) { Time.now }

      it { is_expected.to eq true }
    end
  end
end
