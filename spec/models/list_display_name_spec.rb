require 'spec_helper'

describe ListDisplayName do
  let(:instance) { ListDisplayName.new list }

  describe '#to_str' do
    subject { instance.to_str }

    context 'when the list has list_item_metadata' do
      context 'and the metadata includes display_name' do
        let(:list) do
          double List, name: 'Actual Name', list_item_metadata: { 'display_name' => 'Custom Name' }
        end

        it { is_expected.to eq 'Custom Name' }
      end

      context 'and the metadata does not include display_name' do
        let(:list) do
          double List, name: 'Actual Name', list_item_metadata: {}
        end

        it { is_expected.to eq 'Actual Name' }
      end
    end

    context 'when the list does not have list_item_metadata' do
      let(:list) do
        double List, name: 'Actual Name'
      end

      it { is_expected.to eq 'Actual Name' }
    end
  end

  describe '#to_s' do
    subject { instance.to_s }

    context 'when the list has list_item_metadata' do
      context 'and the metadata includes display_name' do
        let(:list) do
          double List, name: 'Actual Name', list_item_metadata: { 'display_name' => 'Custom Name' }
        end

        it { is_expected.to eq 'Custom Name' }
      end

      context 'and the metadata does not include display_name' do
        let(:list) do
          double List, name: 'Actual Name', list_item_metadata: {}
        end

        it { is_expected.to eq 'Actual Name' }
      end
    end

    context 'when the list does not have list_item_metadata' do
      let(:list) do
        double List, name: 'Actual Name'
      end

      it { is_expected.to eq 'Actual Name' }
    end
  end

  describe '#inspect' do
    subject { instance.inspect }

    context 'when the list has list_item_metadata' do
      context 'and the metadata includes display_name' do
        let(:list) do
          double List, name: 'Actual Name', list_item_metadata: { 'display_name' => 'Custom Name' }
        end

        it { is_expected.to eq '#<ListDisplayName:Custom Name>' }
      end

      context 'and the metadata does not include display_name' do
        let(:list) do
          double List, name: 'Actual Name', list_item_metadata: {}
        end

        it { is_expected.to eq '#<ListDisplayName:Actual Name>' }
      end
    end

    context 'when the list does not have list_item_metadata' do
      let(:list) do
        double List, name: 'Actual Name'
      end

      it { is_expected.to eq '#<ListDisplayName:Actual Name>' }
    end
  end
end
