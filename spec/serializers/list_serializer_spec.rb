require 'spec_helper'

describe ListSerializer do
  describe '#call' do
    let(:list) { create :list, name: 'Dinner' }
    let(:instance) { ListSerializer.new list }

    context 'when there are menu item labels' do
      before do
        create :menu_item, list: list, name: 'General Tso Chicken', labels: ['Spicy']
        create :menu_item, list: list, name: 'Vegetable Lo Mein', labels: ['Vegetarian']
        create :menu_item, list: list, name: 'Herp Derp Delicious', labels: ['Gluten Free', 'Vegan']
      end

      it 'represents menu item labels' do
        result = instance.call
        parsed_result = JSON.parse result

        general_tsos_chicken = parsed_result['beers'].find { |b| b['name'] == 'General Tso Chicken' }
        expect(general_tsos_chicken['labels']).to eq [{
          'name' => 'Spicy',
          'icon' => 'noun_707489_cc'
        }]

        general_tsos_chicken = parsed_result['beers'].find { |b| b['name'] == 'Vegetable Lo Mein' }
        expect(general_tsos_chicken['labels']).to eq [{
          'name' => 'Vegetarian',
          'icon' => 'noun_40436_cc'
        }]

        general_tsos_chicken = parsed_result['beers'].find { |b| b['name'] == 'Herp Derp Delicious' }
        expect(general_tsos_chicken['labels']).to eq [{
          'name' => 'Gluten Free',
          'icon' => 'noun_979958_cc'
        },{
          'name' => 'Vegan',
          'icon' => 'noun_990478_cc'
        }]
      end
    end

    context 'when there are no menu item labels' do
      before do
        create :menu_item, list: list
      end

      it 'represents no labels with an empty array' do
        result = instance.call
        parsed_result = JSON.parse result

        item = parsed_result['beers'].first
        expect(item['labels']).to eq []
      end
    end
  end
end
