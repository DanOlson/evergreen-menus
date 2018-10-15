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

    it 'cannot be missing' do
      expect {
        PriceOption.new
      }.to raise_error(ArgumentError, 'missing keyword: price')
    end

    it 'cannot be set to nil' do
      expect {
        instance.price = nil
      }.to raise_error TypeError
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
  end

  describe '#unit=' do
    it 'sets the unit' do
      instance.unit = 'Bottle'
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
    end
  end
end
