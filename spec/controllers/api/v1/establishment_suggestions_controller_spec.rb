require 'spec_helper'

module Api
  module V1
    describe EstablishmentSuggestionsController do

      describe 'GET to #index' do
        before do
          expect(controller).to receive(:ensure_authenticated_user){ true }
          expect(EstablishmentSuggestion).to receive(:all)
          get :index, format: :json
        end

        it { expect(response).to be_success }
      end

      describe 'POST to #create' do
        let!(:suggestion){ EstablishmentSuggestion.new }
        let(:params){ { name: "Lebowski's", beer_list_url: 'lebowski.com/beers' } }

        before do
          allow(controller).to receive(:valid_api_key?){ true }
          expect(EstablishmentSuggestion).to receive(:new){ suggestion }
          expect(suggestion).to receive(:save){ saved }
          post :create, establishment_suggestion: params, format: :json
        end

        context 'when request is successful' do
          let(:saved){ true }

          it { expect(response.code).to eq '201' }
        end

        context 'when request is a failure' do
          let(:saved){ false }
          
          it { expect(response.code).to eq '400' }
        end
      end

      describe 'DELETE to #destroy' do
        let(:suggestion){ stub_model EstablishmentSuggestion }
        let(:interactor){ double 'interactor', destroy: true }

        before do
          allow(controller).to receive(:ensure_authenticated_user)
          allow(controller).to receive(:find_suggestion){ suggestion }
          expect(controller).to receive(:init_interactor).with(suggestion){ interactor }
          delete :destroy, id: suggestion.id, format: :json
        end

        it { expect(response).to be_success }
      end
    end
  end
end
