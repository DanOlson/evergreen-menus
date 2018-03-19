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
end
