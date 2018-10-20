require 'spec_helper'

describe List do
  describe 'validating menu item price options' do
    let(:list) { create :list }
    let(:item1) { create(:menu_item, name: 'Grits') }
    let(:item2) { create(:menu_item, name: 'Eggs') }

    before do
      list.beers << item1
      list.beers << item2
      [item1, item2].each do |item|
        item.price_options = [
          { price: 6, unit: 'glass' },
          { price: 38, unit: 'glass' },
        ]
      end
      list.valid?
    end

    it 'is not valid' do
      expect(list).to_not be_valid
    end

    it 'consolidates the messages to the list' do
      expect(list.errors.full_messages).to eq ['Item price options may not have duplicate units']
    end
  end
end
