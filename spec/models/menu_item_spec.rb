require 'spec_helper'

describe 'MenuItem' do
  describe '#labels' do
    let(:instance) { build :menu_item }

    it 'responds to #labels' do
      expect(instance).to respond_to :labels
    end

    it 'a label can be saved' do
      instance.labels = [Label.new(name: 'Spicy')]
      instance.save && instance.reload
      expect(instance.labels.map(&:name)).to eq ['Spicy']
    end

    it 'labels can be assigned from strings' do
      instance.labels = ['Spicy', 'Vegetarian']
      expect(instance.labels.map(&:name)).to eq ['Spicy', 'Vegetarian']
      instance.save && instance.reload
      expect(instance.labels.map(&:name)).to eq ['Spicy', 'Vegetarian']
    end

    it 'does not save empty labels' do
      instance.labels = ['', 'Vegetarian']
      expect(instance.labels.map(&:name)).to eq ['Vegetarian']
      instance.save && instance.reload
      expect(instance.labels.map(&:name)).to eq ['Vegetarian']
    end

    it 'multiple labels can be saved' do
      instance.labels = [
        Label.new(name: 'Spicy'),
        Label.new(name: 'Gluten Free'),
        Label.new(name: 'Vegan')
      ]
      instance.save && instance.reload
      expect(instance.labels.map(&:name)).to eq ['Spicy', 'Gluten Free', 'Vegan']
    end
  end

  describe '#as_json' do
    let(:timestamp) { Time.now }
    let(:instance) do
      Beer.new(
        id: 15,
        name: 'Coors',
        created_at: timestamp,
        updated_at: timestamp,
        establishment_id: 1,
        price: '3',
        description: 'sucks',
        position: 0
      )
    end

    it 'represents the expected properties' do
      actual = instance.as_json
      expect(actual).to match hash_including({
        'id' => 15,
        'name' => 'Coors',
        'created_at' => timestamp,
        'updated_at' => timestamp,
        'establishment_id' => 1,
        'price' => 3.0,
        'description' => 'sucks',
        'position' => 0,
        'labels' => []
      })
    end
  end

  describe '#position' do
    it 'requires position' do
      b = Beer.new and b.valid?
      expect(b.errors[:position]).to eq ["can't be blank"]
    end
  end

  describe '#price_options' do
    context 'without any options' do
      let(:instance) { Beer.new }

      it 'returns empty array' do
        expect(instance.price_options).to eq []
      end
    end

    context 'with options' do
      let(:instance) do
        Beer.new price_options: [{
          price: 9,
          unit: 'Glass'
        },{
          price: 45,
          unit: 'Bottle'
        }]
      end

      it 'returns an array of PriceOptions' do
        expect(instance.price_options).to all be_a PriceOption
      end
    end
  end

  describe '#price_options=' do
    let(:instance) { Beer.new }

    before do
      instance.price_options = options
    end

    context 'when given an array of valid hashes' do
      let(:options) do
        [
          { price: 4, unit: '16oz' },
          { price: 7, unit: '32oz' }
        ]
      end

      it 'writes complete PriceOption data' do
        expect(instance.read_attribute(:price_options)).to eq [
          {
            'price' => 4.0,
            'currency' => 'USD',
            'unit' => '16oz'
          },
          {
            'price' => 7.0,
            'currency' => 'USD',
            'unit' => '32oz'
          }
        ]
      end

      context 'and some are missing prices' do
        let(:options) do
          [
            { price: 4, unit: '16oz' },
            { price: nil, unit: '32oz' }
          ]
        end

        it 'rejects those that are missing a price value' do
          expect(instance.read_attribute(:price_options)).to eq [
            {
              'price' => 4.0,
              'currency' => 'USD',
              'unit' => '16oz'
            }
          ]
        end
      end
    end

    context 'when given an array of PriceOptions' do
      context 'that are all valid' do
        let(:options) do
          [
            PriceOption.new(price: 1, unit: 'foo'),
            PriceOption.new(price: 3, unit: 'bar'),
            PriceOption.new(price: 5, unit: 'baz'),
          ]
        end

        it 'accepts the data' do
          expect(instance.read_attribute(:price_options)).to eq [
            { 'price' => 1.0, 'currency' => 'USD', 'unit' => 'foo' },
            { 'price' => 3.0, 'currency' => 'USD', 'unit' => 'bar' },
            { 'price' => 5.0, 'currency' => 'USD', 'unit' => 'baz' }
          ]
        end
      end

      context 'and some have no price value' do
        let(:options) do
          [
            PriceOption.new(price: nil, unit: 'foo'),
            PriceOption.new(price: nil, unit: 'bar'),
            PriceOption.new(price: 5, unit: 'baz'),
          ]
        end

        it 'rejects options with no price value' do
          expect(instance.read_attribute(:price_options)).to eq [
            { 'price' => 5.0, 'currency' => 'USD', 'unit' => 'baz' }
          ]
        end
      end
    end

    context 'when given a single hash value' do
      let(:options) do
        { price: 6, unit: 'Lb' }
      end

      it 'transforms it to an array' do
        expect(instance.read_attribute(:price_options)).to eq [
          { 'price' => 6.0, 'currency' => 'USD', 'unit' => 'Lb' }
        ]
      end
    end

    context 'when given a single PriceOption' do
      let(:options) { PriceOption.new(price: 6, unit: 'Lb') }

      it 'transforms it to an array' do
        expect(instance.read_attribute(:price_options)).to eq [
          { 'price' => 6.0, 'currency' => 'USD', 'unit' => 'Lb' }
        ]
      end
    end

    context 'when given multiple options of the same unit' do
      let(:instance) { build :menu_item }
      let(:options) do
        [
          { price: 4, unit: 'bowl' },
          { price: 7, unit: 'bowl' }
        ]
      end

      it 'invalidates the menu item' do
        expect(instance).to_not be_valid
      end
    end
  end

  describe '#price' do
    context 'when there are price_options available' do
      let(:instance) do
        Beer.new price: '22', price_options: [{ price: 14 }]
      end

      it 'returns the value of the first option' do
        expect(instance.price).to eq 14.00
      end
    end

    context 'when there are no price_options available' do
      let(:instance) do
        Beer.new price: '22'
      end

      it 'falls back to the native "price" value' do
        expect(instance.price).to eq 22.00
      end
    end
  end
end
