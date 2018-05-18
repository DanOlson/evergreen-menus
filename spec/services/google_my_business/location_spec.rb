require 'spec_helper'

module GoogleMyBusiness
  describe Location do
    let(:instance) { Location.new data }

    describe '#name' do
      subject { instance.name }
      let(:data) do
        { 'name' => 'accounts/123/locations/456' }
      end

      it { is_expected.to eq 'accounts/123/locations/456' }
    end

    describe '#location_name' do
      subject { instance.location_name }
      let(:data) do
        { 'locationName' => 'foobar' }
      end

      it { is_expected.to eq 'foobar' }
    end

    describe '#price_list' do
      subject(:price_list) { instance.price_list }

      context 'when there is a priceList in the source data' do
        let(:data) do
          {
            'priceLists' => [
              {
                'priceListId' => 'dinner',
                'labels' => [{ 'displayName' => 'Dinner' }]
              }
            ]
          }
        end

        it { is_expected.to be_a PriceList }

        it 'has the right name' do
          expect(price_list.name).to eq 'Dinner'
        end

        it 'has no sections' do
          expect(price_list.sections).to eq []
        end
      end

      context 'when there is no price list in the source data' do
        let(:data) { {} }

        it { is_expected.to be_a PriceList }

        it 'has the default name' do
          expect(price_list.name).to eq 'Menu'
        end

        it 'has no sections' do
          expect(price_list.sections).to eq []
        end
      end
    end
  end
end
