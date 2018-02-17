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
end
