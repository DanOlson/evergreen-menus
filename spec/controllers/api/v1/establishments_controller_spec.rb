require 'spec_helper'

module Api
  module V1
    describe EstablishmentsController do
      let(:establishment){ stub_model Establishment, address: '123 foo street' }

      describe 'GET to #show' do
        before do
          expect(controller).to receive(:find_establishment){ establishment }
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

      describe 'PATCH to #update' do
        context 'when not authenticated' do
          it 'returns 401' do
            patch :update, id: 1, format: :json
            expect(response.status).to eq 401
          end
        end

        context 'when authenticated' do
          let(:params) do
            {
              name: 'Foo',
              url: 'http://example.com',
              active: false
            }
          end

          before do
            expect(controller).to receive(:ensure_authenticated_user){ true }
          end

          context 'success' do
            before do
              expect(controller).to receive(:find_establishment){ establishment }
            end

            it 'updates the record' do
              expect(establishment).to receive(:update_attributes).with params.stringify_keys
              patch :update, id: 1, establishment: params, format: :json
            end

            it 'returns 204' do
              allow(establishment).to receive :update_attributes
              patch :update, id: 1, establishment: params, format: :json
              expect(response.status).to eq 204
            end
          end

          context 'failure' do
            let(:params){ super().merge(name: '', url: '') }

            before do
              expect(controller).to receive(:find_establishment){ establishment }
              patch :update, id: 1, establishment: params, format: :json
            end

            it 'returns the appropriate errors' do
              expected = {
                errors: {
                  name: ["can't be blank"],
                  url: ["can't be blank"]
                }
              }.to_json
              expect(response.body).to eq expected
            end

            it 'returns 422' do
              expect(response.status).to eq 422
            end
          end
        end
      end
    end
  end
end
