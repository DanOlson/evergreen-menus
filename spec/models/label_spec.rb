require 'spec_helper'

describe Label do
  describe '.from' do
    context 'string' do
      it 'returns a Label with a name of +string+' do
        foo = Label.from('foo')
        bar = Label.from('bar')
        expect(foo.name).to eq 'foo'
        expect(bar.name).to eq 'bar'
      end
    end

    context 'another Label instance' do
      it 'returns the given instance' do
        label = Label.new(name: 'Sweet')
        expect(Label.from(label)).to eq label
      end
    end
  end

  describe '#icon' do
    let(:instance) { Label.new(name: label_name) }
    subject { instance.icon }

    context 'with label named "Gluten Free"' do
      let(:label_name) { 'Gluten Free' }

      it { is_expected.to eq 'noun_979958_cc' }
    end

    context 'with label named "Vegan"' do
      let(:label_name) { 'Vegan' }

      it { is_expected.to eq 'noun_990478_cc' }
    end

    context 'with label named "Vegetarian"' do
      let(:label_name) { 'Vegetarian' }

      it { is_expected.to eq 'noun_40436_cc' }
    end

    context 'with label named "Spicy"' do
      let(:label_name) { 'Spicy' }

      it { is_expected.to eq 'noun_707489_cc' }
    end

    context 'with label named "Dairy Free"' do
      let(:label_name) { 'Dairy Free' }

      it { is_expected.to eq 'noun_990484_cc' }
    end

    context 'with label named "House Special"' do
      let(:label_name) { 'House Special' }

      it { is_expected.to eq 'noun_1266172_cc' }
    end

    context 'when there is no icon for the label' do
      let(:label_name) { 'Cold as ice' }

      it { is_expected.to be_nil }
    end
  end

  describe '#as_json' do
    context 'when the label has an icon' do
      let(:instance) { Label.new(name: 'Spicy') }

      it 'includes name and icon' do
        expect(instance.as_json).to eq({
          'name' => 'Spicy',
          'icon' => 'noun_707489_cc'
        })
      end
    end

    context 'when the label has no icon' do
      let(:instance) { Label.new(name: 'Sinful') }

      it 'includes just name' do
        expect(instance.as_json).to eq({ 'name' => 'Sinful' })
      end
    end
  end
end
