require 'spec_helper'

describe ListSerializer do
  describe '#call' do
    let(:list) { create :list, name: 'Dinner' }
    let(:instance) { ListSerializer.new list }

    describe 'as_json' do
      subject { instance.call(as_json: as_json) }

      context 'when true' do
        let(:as_json) { true }
        it { is_expected.to be_a Hash }
      end

      context 'when false' do
        let(:as_json) { false }
        it { is_expected.to be_a String }
      end
    end

    describe 'href' do
      context 'when the list is persisted' do
        it 'provides a link' do
          result = instance.call
          parsed_result = JSON.parse(result)
          expected = "/accounts/#{list.establishment.account_id}/establishments/#{list.establishment_id}/lists/#{list.id}/edit"

          expect(parsed_result['href']).to eq expected
        end
      end

      context 'when the list is not persisted' do
        let(:list) { build :list }

        it 'does not provide a link' do
          result = instance.call
          parsed_result = JSON.parse(result)

          expect(parsed_result).to_not have_key 'href'
        end
      end
    end

    describe 'itemCount' do
      context 'when the list is not persisted' do
        let(:list) { build :list }

        it 'is zero' do
          result = instance.call
          parsed_result = JSON.parse(result)

          expect(parsed_result['itemCount']).to eq 0
        end
      end

      context 'when the list has 5 items' do
        let(:list) { create :list, :with_items, item_count: 5 }

        it 'is zero' do
          result = instance.call
          parsed_result = JSON.parse(result)

          expect(parsed_result['itemCount']).to eq 5
        end
      end
    end

    context 'when there are menu item labels' do
      before do
        create :menu_item, list: list, name: 'General Tso Chicken', labels: ['Spicy']
        create :menu_item, list: list, name: 'Vegetable Lo Mein', labels: ['Vegetarian']
        create :menu_item, list: list, name: 'Herp Derp Delicious', labels: ['Gluten Free', 'Vegan']
      end

      it 'represents menu item labels' do
        result = instance.call(include_items: true)
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
        result = instance.call(include_items: true)
        parsed_result = JSON.parse result

        item = parsed_result['beers'].first
        expect(item['labels']).to eq []
      end
    end

    describe 'representing items' do
      let(:list) { create :list, :with_items, item_count: 3 }
      let(:result) { instance.call(include_items: include_items) }

      context 'when include_items is true' do
        let(:include_items) { true }

        it 'items are included in the representation' do
          parsed_result = JSON.parse(result)
          expect(parsed_result['beers'].size).to eq 3
        end
      end

      context 'when include_items is false' do
        let(:include_items) { false }

        it 'items are not included in the representation' do
          parsed_result = JSON.parse(result)
          expect(parsed_result).to_not have_key 'beers'
        end
      end

      context 'when include_items is omitted' do
        let(:result) { instance.call }

        it 'items are not included in the representation' do
          parsed_result = JSON.parse(result)
          expect(parsed_result).to_not have_key 'beers'
        end
      end
    end
  end
end
