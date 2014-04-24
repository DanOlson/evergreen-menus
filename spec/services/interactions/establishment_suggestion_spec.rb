require 'fast_spec_helper'

module Interactions
  describe EstablishmentSuggestion do
    describe '#destroy' do
      let(:now){ Time.now }
      let(:suggestion){ double 'establishment_suggestion', update_attributes: true }
      let(:instance){ described_class.new suggestion }

      before do
        allow(instance).to receive(:now){ now }
      end

      it 'soft-deletes the record' do
        instance.destroy
        expect(suggestion).to have_received(:update_attributes).with deleted_at: now
      end
    end
  end
end
