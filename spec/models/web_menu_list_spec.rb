require 'spec_helper'

describe WebMenuList do
  describe '#display_name=' do
    context 'when there is no data in list_item_metadata' do
      let(:instance) do
        WebMenuList.new
      end

      it 'adds display_name to the metadata' do
        instance.display_name = 'Kids Breakfast'
        expect(instance.list_item_metadata['display_name']).to eq 'Kids Breakfast'
      end
    end

    context 'when there is list_item_metadata' do
      let(:instance) do
        WebMenuList.new list_item_metadata: { foo: 'bar' }
      end

      it 'adds to the existing metadata' do
        instance.display_name = 'Kids Breakfast'
        expect(instance.list_item_metadata['display_name']).to eq 'Kids Breakfast'
        expect(instance.list_item_metadata['foo']).to eq 'bar'
      end
    end
  end

  describe '#html_classes=' do
    context 'when there is no data in list_item_metadata' do
      let(:instance) do
        WebMenuList.new
      end

      it 'adds html_classes to the metadata' do
        instance.html_classes = 'col-2 awesome'
        expect(instance.list_item_metadata['html_classes']).to eq 'col-2 awesome'
      end
    end

    context 'when there is list_item_metadata' do
      let(:instance) do
        WebMenuList.new list_item_metadata: { foo: 'bar' }
      end

      it 'adds to the existing metadata' do
        instance.html_classes = 'col-2 awesome'
        expect(instance.list_item_metadata['html_classes']).to eq 'col-2 awesome'
        expect(instance.list_item_metadata['foo']).to eq 'bar'
      end
    end
  end
end
