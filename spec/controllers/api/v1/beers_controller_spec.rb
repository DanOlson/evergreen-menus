require 'spec_helper'

module Api
  module V1
    describe BeersController do

      describe 'GET to #index' do
        let(:establishment){ double Establishment }

        before do
          rel = double('relation')
          expect(Beer).to receive(:at_establishment).with('1').and_return(rel)
          expect(rel).to receive(:names_like).and_return([])
          get :index, establishment_id: 1, format: :json 
        end

        it { expect(response).to be_success }

      end
    end
  end
end
