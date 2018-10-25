require 'spec_helper'

describe OnlineMenuList do
  describe '#display_name=' do
    context 'when there is no data in list_item_metadata' do
      let(:instance) do
        OnlineMenuList.new
      end

      it 'adds display_name to the metadata' do
        instance.display_name = 'Kids Breakfast'
        expect(instance.list_item_metadata['display_name']).to eq 'Kids Breakfast'
      end
    end

    context 'when there is list_item_metadata' do
      let(:instance) do
        OnlineMenuList.new list_item_metadata: { foo: 'bar' }
      end

      it 'adds to the existing metadata' do
        instance.display_name = 'Kids Breakfast'
        expect(instance.list_item_metadata['display_name']).to eq 'Kids Breakfast'
        expect(instance.list_item_metadata['foo']).to eq 'bar'
      end
    end
  end
end
