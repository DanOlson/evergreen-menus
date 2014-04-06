require 'fast_spec_helper'

module ListManagement
  describe BeerListUpdater do
    let(:current_beers){ %w(Moylan's McSorley's bud coors summit) }
    let(:beers){ double 'CollectionProxy', pluck: current_beers }
    let(:establishment){ double('establishment', beers: beers) }
    let(:list){ %w(bud miller coors summit) }
    let(:instance){ BeerListUpdater.new establishment, list }

    describe '.update!' do
      let(:instance){ double(update!: true) }

      it 'instantiates an instance' do
        expect(BeerListUpdater).to receive(:new){ instance }
        BeerListUpdater.update! establishment, []
      end

      it 'calls #update! on the instance' do
        allow(BeerListUpdater).to receive(:new){ instance }
        BeerListUpdater.update! establishment, []
        expect(instance).to have_received(:update!)
      end
    end

    describe '#new_beer_names' do
      it "returns the list of names it doesn't already have" do
        expect(instance.new_beer_names).to eq(['miller'])
      end
    end

    describe '#old_beer_names' do
      it 'returns a list of names that need to be removed' do
        expect(instance.old_beer_names).to eq(%w(Moylan's McSorley's))
      end
    end

    describe '#update!' do
      let(:rel){ double }

      shared_examples 'unacceptable update' do
        it 'should not delete any current beers' do
          expect(instance).to_not receive :delete_old_beers
          instance.update!
        end

        it 'should not create any new beers' do
          expect(instance).to_not receive :create_new_beers
          instance.update!
        end

        it 'yields a (failure) status object' do
          x = false
          res = instance.update! do |status|
            status.on_failure do
              x = true
            end
          end
          expect(x).to eq true
        end
      end

      it 'should delete the old beer names' do
        expect(Beer).to receive(:where).with(name: %w(Moylan's McSorley's)){ rel }
        expect(beers).to receive(:delete).with rel
        allow(instance).to receive(:create_new_beers)
        instance.update!
      end

      it 'should add the new beer names to the establishment' do
        beer = double
        allow(instance).to receive(:delete_old_beers)
        expect(Beer).to receive(:where).with(name: 'miller'){ rel }
        expect(rel).to receive(:first_or_create){ beer }
        expect(beers).to receive(:<<).with beer
        instance.update!
      end

      context 'when the list is empty (the markup has likely changed)' do
        let(:list){ [] }

        it_behaves_like 'unacceptable update'
      end

      context 'when the new list is less than 80% of the current list' do
        let(:list){ super()[0..-3] }

        it_behaves_like 'unacceptable update'

        context 'when the +force+ option is passed' do
          it 'should delete the old beer names' do
            expect(Beer).to receive(:where).with(name: %w(Moylan's McSorley's coors summit)){ rel }
            expect(beers).to receive(:delete).with rel
            allow(instance).to receive(:create_new_beers)
            instance.update! force: true
          end

          it 'should add the new beer names to the establishment' do
            beer = double
            allow(instance).to receive(:delete_old_beers)
            expect(Beer).to receive(:where).with(name: 'miller'){ rel }
            expect(rel).to receive(:first_or_create){ beer }
            expect(beers).to receive(:<<).with beer
            instance.update! force: true
          end
        end
      end
    end
  end
end
