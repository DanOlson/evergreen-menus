require 'spec_helper'

describe Theme do
  describe '.find_by_name' do
    subject(:theme) { Theme.find_by_name(theme_name) }

    context 'when given a valid name' do
      let(:theme_name) { 'Standard' }

      it { is_expected.to be_a Theme }

      it 'has the correct name' do
        expect(theme.name).to eq theme_name
      end

      it 'has the correct font' do
        expect(theme.font).to eq 'Architects Daughter'
      end

      it 'has the correct background_color' do
        expect(theme.background_color).to eq '#FFF'
      end

      it 'has the correct text_color' do
        expect(theme.text_color).to eq '#040000'
      end

      it 'has the correct list_title_color' do
        expect(theme.list_title_color).to eq '#d40a0a'
      end
    end

    context 'when given an invalid name' do
      let(:theme_name) { 'foo' }

      it { is_expected.to be_nil }
    end
  end
end
