require 'spec_helper'

module Api
  module V1
    describe EstablishmentsController do

      describe 'GET to #show' do
        before do
          allow(Establishment).to receive(:find){ stub_model(Establishment) }
        end

        it { expect(response).to be_success }
      end

      describe 'GET to #index' do
        let(:rel){ double }

        before do
          allow(Establishment).to receive(:order){ rel }
          allow(rel).to receive(:page)
          get :index
        end

        it { expect(response).to be_success }
      end

      describe 'POST to #create' do
        let(:list){ ['Surly Darkness', 'Three Floyds Zombie Dust'] }
        let(:beer_list) do
          [{ name: 'Muddy Waters', address: nil, list: list }.to_json]
        end

        context 'with the correct API key' do
          before do
            expect(controller).to receive(:valid_api_key?){ true }
            expected = { name: 'Muddy Waters', address: nil, list: list }
            expect(Establishment).to receive(:update_list!).with(expected)
            post :create, beer_list: beer_list, api_key: 'Lebowski', format: :json
          end

          it { expect(response).to be_success }
        end

        context 'with an incorrect API key' do
          before do
            expect(controller).to receive(:valid_api_key?){ false }
            expect(Establishment).to_not receive(:update_list!)
            post :create, beer_list: beer_list, api_key: 'Sobchak', format: :json
          end
        end
      end
    end
  end
end
