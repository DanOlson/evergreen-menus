require File.expand_path('../../../../app/services/list_management/beer_list_fetcher', __FILE__)

module ListManagement
  describe BeerListFetcher do
    describe '#lists' do
      let(:est1){ double name: 'est1' }
      let(:est2){ double name: 'est2', list: [] }
      let(:logger){ double warn: nil }
      let(:fetcher){ BeerListFetcher.new logger }

      before do
        allow(est1).to receive(:list).and_raise StandardError.new('something broke!')
        allow(fetcher).to receive(:establishments){ [est1, est2] }
      end

      it 'rescues errors and logs them' do
        fetcher.lists
        expect(logger).to have_received(:warn)
      end

      it 'continues to execute' do
        fetcher.lists
        expect(est2).to have_received :list
      end
    end
  end
end
