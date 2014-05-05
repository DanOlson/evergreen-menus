require 'spec_helper'

module Queries
  describe ListUpdate do
    before(:all) do
      Establishment.skip_callback(:create, :after, :geocode)
    end
    let(:args){ {} }
    let(:instance){ ListUpdate.new args }
    let(:results){ instance.run }

    let!(:bar1){ Establishment.create! name: 'Bar1', address: '123 Main' }
    let!(:bar2){ Establishment.create! name: 'Bar2', address: '123 2nd St' }
    let!(:bar3){ Establishment.create! name: 'Bar3', address: '300 University' }

    let!(:successful_update1){ ::ListUpdate.create! establishment: bar1, status: 'Success' }
    let!(:successful_update2){ ::ListUpdate.create! establishment: bar2, status: 'Success' }
    let!(:failed_update)     { ::ListUpdate.create! establishment: bar3, status: 'Failed' }
    let!(:old_successful_update1) do
      ::ListUpdate.create!({
        establishment: bar1,
        status: 'Success',
        created_at: '2014-03-15'
      })
    end
    let!(:old_successful_update2) do
      ::ListUpdate.create!({
        establishment: bar2,
        status: 'Success',
        created_at: '2014-03-15'
      })
    end
    let!(:old_failed_update) do
      ::ListUpdate.create!({
        establishment: bar3,
        status: 'Failed',
        created_at: '2014-03-17'
      })
    end

    shared_examples 'run' do
      it 'includes expected results' do
        expect(results).to match_array expected
      end
    end

    describe 'status' do
      let(:args){ super().merge status: status }

      context 'when success' do
        let(:status){ 'success' }
        let(:expected) do
          [
            successful_update1,
            successful_update2,
            old_successful_update1,
            old_successful_update2,
          ]
        end

        it_behaves_like 'run'
      end

      context 'when failed' do
        let(:status){ 'failed' }
        let!(:expected) do
          [failed_update, old_failed_update]
        end

        it_behaves_like 'run'
      end
    end

    describe 'establishment_id' do
      let(:args){ super().merge establishment_id: bar1.id }
      let(:expected) do
        [successful_update1, old_successful_update1]
      end

      it_behaves_like 'run'
    end

    describe 'dates' do
      let(:args){ super().merge start_date: start_date, end_date: end_date }

      describe 'requesting a single day' do
        let(:start_date){ '2014-03-15' }
        let(:end_date){ '2014-03-15' }
        let(:expected) do
          [old_successful_update1, old_successful_update2]
        end

        it_behaves_like 'run'
      end

      describe 'requesting a date range' do
        let(:start_date){ '2014-03-15' }
        let(:end_date){ '2014-03-17' }
        let(:expected) do
          [old_successful_update1, old_successful_update2, old_failed_update]
        end

        it_behaves_like 'run'
      end
    end
  end
end
