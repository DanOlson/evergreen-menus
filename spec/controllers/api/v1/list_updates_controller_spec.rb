require 'spec_helper'

module Api
  module V1
    describe ListUpdatesController do
      describe 'GET to #index' do
        context 'when authenticated' do
          let(:establishment){ stub_model Establishment, name: 'Dude' }
          let(:first) do
            stub_model ListUpdate,
              establishment: establishment,
              raw_data: { list: ['Miller'] }.to_json
          end
          let(:second) do
            stub_model ListUpdate,
              establishment: establishment,
              raw_data: { list: ['Bud'] }.to_json
          end
          let(:relation){ double 'relation', includes: updates }
          let(:updates){ [first, second] }

          before do
            expect(controller).to receive(:ensure_authenticated_user){ true }
            expect(ListUpdate).to receive(:most_recent){ relation }
            get :index, format: :json
          end

          it 'returns 200' do
            expect(response.status).to eq 200
          end

          it 'returns the correct JSON' do
            expected = {
              list_updates: [
                {
                  id: first.id,
                  establishment_id: first.establishment_id,
                  name: establishment.name,
                  status: first.status,
                  raw_data: first.raw_data,
                  notes: first.notes,
                  created_at: first.created_at
                },
                {
                  id: second.id,
                  establishment_id: second.establishment_id,
                  name: establishment.name,
                  status: second.status,
                  raw_data: second.raw_data,
                  notes: second.notes,
                  created_at: second.created_at
                }
              ]
            }.to_json
            expect(response.body).to eq expected
          end
        end

        context 'when not authenticated' do
          it 'returns 401' do
            get :index, format: :json
            expect(response.status).to eq 401
          end
        end
      end
    end
  end
end
