require 'spec_helper'

describe PriceOption do
  let(:instance) { PriceOption.new price: 4.5 }

  describe '#price' do
    it 'returns the price' do
      expect(instance.price).to eq 4.5
    end
  end

  describe '#price=' do
    it 'sets the price' do
      instance.price = 5.0
      expect(instance.price).to eq 5.0
    end

    it 'transforms strings to floats' do
      instance.price = '5'
      expect(instance.price).to eq 5.0

      instance.price = '5.95'
      expect(instance.price).to eq 5.95
    end

    it 'can be set to nil' do
      instance.price = nil
      expect(instance.price).to eq nil
    end

    context 'when given empty string' do
      it 'is set to nil' do
        instance.price = ''
        expect(instance.price).to eq nil
      end

      it 'constructor sets emtpy to nil' do
        instance = PriceOption.new price: ''
        expect(instance.price).to eq nil
      end
    end
  end

  describe '#currency' do
    it 'has a default value' do
      expect(instance.currency).to eq 'USD'
    end
  end

  describe '#currency=' do
    it 'sets the currency' do
      instance.currency = 'EUR'
      expect(instance.currency).to eq 'EUR'
    end
  end

  describe '#unit' do
    it 'has a default value' do
      expect(instance.unit).to eq 'Serving'
    end

    it 'strips whitespace from the given value' do
      instance = PriceOption.new price: 4, unit: '16oz   '
      expect(instance.unit).to eq '16oz'
    end
  end

  describe '#unit=' do
    it 'sets the unit' do
      instance.unit = 'Bottle'
      expect(instance.unit).to eq 'Bottle'
    end

    it 'strips the value of leading and trailing whitespace' do
      instance.unit = ' Bottle '
      expect(instance.unit).to eq 'Bottle'
    end
  end

  describe '#as_json' do
    it 'returns the expected hash' do
      expected = {
        'price' => 4.5,
        'currency' => 'USD',
        'unit' => 'Serving'
      }
      expect(instance.as_json).to eq expected
    end
  end

  describe '#to_json' do
    it 'returns the expected JSON' do
      expected = '{"price":4.5,"currency":"USD","unit":"Serving"}'
      expect(instance.to_json).to eq expected
    end
  end

  describe '.from' do
    let(:instance) { PriceOption.from arg }

    context 'when given a PriceOption' do
      let(:arg) { PriceOption.new price: 6 }

      it 'returns it' do
        expect(instance).to equal arg
      end
    end

    context 'when given a hash' do
      let(:arg) do
        {
          price: 7,
          unit: 'Glass'
        }
      end

      it 'returns a PriceOption from the hash data' do
        expect(instance.price).to eq 7.0
        expect(instance.unit).to eq 'Glass'
        expect(instance.currency).to eq 'USD'
      end

      context 'with string keys' do
        let(:arg) { super().stringify_keys }

        it 'returns a PriceOption from the hash data' do
          expect(instance.price).to eq 7.0
          expect(instance.unit).to eq 'Glass'
          expect(instance.currency).to eq 'USD'
        end
      end
    end
  end
end
