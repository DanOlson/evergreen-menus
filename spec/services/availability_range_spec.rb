require 'spec_helper'

describe AvailabilityRange do
  describe '#call' do
    subject { AvailabilityRange.call menu }

    context 'when the provided menu has both start and end times' do
      let(:menu) do
        double 'menu', {
          availability_start_time: Time.zone.parse('06:00 PM'),
          availability_end_time: Time.zone.parse('12:00 AM')
        }
      end

      it { is_expected.to eq '6:00 pm - 12:00 am' }
    end

    context 'when the provided menu has a start time but no end time' do
      let(:menu) do
        double 'menu', {
          availability_start_time: Time.zone.parse('06:00 PM'),
          availability_end_time: nil
        }
      end

      it { is_expected.to eq '6:00 pm' }
    end

    context 'when the provided menu has an end time but no start time' do
      let(:menu) do
        double 'menu', {
          availability_start_time: nil,
          availability_end_time: Time.zone.parse('12:00 AM')
        }
      end

      it { is_expected.to eq 'until 12:00 am' }
    end

    context 'when the provided menu has no end time or start time' do
      let(:menu) do
        double 'menu', {
          availability_start_time: nil,
          availability_end_time: nil
        }
      end

      it { is_expected.to eq '' }
    end
  end
end
