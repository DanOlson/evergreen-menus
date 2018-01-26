require 'spec_helper'

describe DigitalDisplayMenu do
  describe '#theme' do
    let(:instance) do
      DigitalDisplayMenu.new(theme: theme)
    end

    subject { instance.theme }

    context 'when the assigned value represents a known theme' do
      let(:theme) { 'Granola' }

      it 'returns the Theme object' do
        expect(subject).to be_a Theme
      end

      it 'returns the theme with the given name' do
        expect(subject.name).to eq theme
      end
    end

    context 'when the assigned value does not represent a known theme' do
      let(:theme) { 'HerP' }

      it 'returns the default theme' do
        expect(subject).to be_a Theme
        expect(subject.name).to eq 'Standard'
      end
    end

    context 'when assigning nil' do
      let(:theme) { nil }

      it 'returns the default theme' do
        expect(subject).to be_a Theme
        expect(subject.name).to eq 'Standard'
      end
    end

    context 'when the theme is unassigned' do
      let(:instance) { DigitalDisplayMenu.new }

      it 'returns the default theme' do
        expect(subject).to be_a Theme
        expect(subject.name).to eq 'Standard'
      end
    end
  end

  describe '#background_color' do
    context 'when unassigned' do
      let(:instance) { DigitalDisplayMenu.new(theme: 'Ireland') }

      it 'returns the value from the theme' do
        expect(instance.background_color).to eq '#293b2a'
      end
    end

    context 'when assigned' do
      let(:instance) do
        DigitalDisplayMenu.new(theme: 'Dark', background_color: '#FFF')
      end

      it 'returns the assigned value' do
        expect(instance.background_color).to eq '#FFF'
      end
    end
  end

  describe '#font' do
    context 'when unassigned' do
      let(:instance) { DigitalDisplayMenu.new }

      it 'returns the value from the theme' do
        expect(instance.font).to eq 'Architects Daughter'
      end
    end

    context 'when assigned' do
      let(:instance) do
        DigitalDisplayMenu.new(font: 'Walter Turncoat')
      end

      it 'returns the assigned value' do
        expect(instance.font).to eq 'Walter Turncoat'
      end
    end
  end

  describe '#text_color' do
    context 'when unassigned' do
      let(:instance) { DigitalDisplayMenu.new }

      it 'returns the value from the theme' do
        expect(instance.text_color).to eq '#040000'
      end
    end

    context 'when assigned' do
      let(:instance) do
        DigitalDisplayMenu.new(text_color: '#cecece')
      end

      it 'returns the assigned value' do
        expect(instance.text_color).to eq '#cecece'
      end
    end
  end

  describe '#list_title_color' do
    context 'when unassigned' do
      let(:instance) { DigitalDisplayMenu.new }

      it 'returns the value from the theme' do
        expect(instance.list_title_color).to eq '#d40a0a'
      end
    end

    context 'when assigned' do
      let(:instance) do
        DigitalDisplayMenu.new(list_title_color: '#040000')
      end

      it 'returns the assigned value' do
        expect(instance.list_title_color).to eq '#040000'
      end
    end
  end
end
