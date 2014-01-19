require 'spec_helper'

module Api
  module V1
    describe EstablishmentsController do

      describe 'GET to #show' do
        before do
          rel = double
          allow(Establishment).to receive(:active){ rel }
          expect(rel).to receive(:find){ stub_model(Establishment) }
          get :show, id: 1, format: :json
        end

        it { expect(response).to be_success }
      end

      describe 'GET to #index' do
        let(:rel){ double }

        before do
          allow(Establishment).to receive(:order){ rel }
          allow(rel).to receive(:page)
          get :index, format: :json
        end

        it { expect(response).to be_success }
      end
    end
  end
end
