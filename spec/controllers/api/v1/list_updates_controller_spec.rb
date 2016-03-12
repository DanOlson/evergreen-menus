require 'spec_helper'

module Api
  module V1
    describe ListUpdatesController do
      let(:establishment){ Establishment.new name: 'Dude' }
      let(:first) do
        ListUpdate.new({
          id: 1,
          establishment: establishment,
          raw_data: { list: ['Miller'] }.to_json
        })
      end
      let(:second) do
        ListUpdate.new({
          id: 2,
          establishment: establishment,
          raw_data: { list: ['Bud'] }.to_json
        })
      end
      let(:updates){ [first, second] }

      describe 'GET to #index' do
        context 'when authenticated' do
          before do
            expect(controller).to receive(:ensure_authenticated_user){ true }
            expect(controller).to receive(:find_list_updates){ updates }
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

      describe 'GET to #show' do
        context 'when authenticated' do
          before do
            expect(controller).to receive(:ensure_authenticated_user){ true }
            expect(ListUpdate).to receive(:find){ first }
            get :show, params: { id: first.id }, format: :json
          end

          it 'returns 200' do
            expect(response.status).to eq 200
          end

          it 'returns the correct JSON' do
            expected = {
              list_update: {
                id: first.id,
                establishment_id: first.establishment_id,
                name: establishment.name,
                status: first.status,
                raw_data: first.raw_data,
                notes: first.notes,
                created_at: first.created_at
              }
            }.to_json

            expect(response.body).to eq expected
          end
        end

        context 'when not authenticated' do
          it 'returns 401' do
            get :show, params: { id: first.id }, format: :json
            expect(response.status).to eq 401
          end
        end
      end

      describe 'POST to #create' do
        context 'when not authenticated' do
          it 'returns 401' do
            post :create, params: { list_update: {} }, format: :json
            expect(response.status).to eq 401
          end
        end

        context 'when authenticated' do
          let(:establishment){ Establishment.new id: 1 }
          let(:list_update){ ListUpdate.new establishment: establishment }
          let(:scraper){ double 'Scraper' }
          let(:interactor){ double 'Interactions::Scraper', scrape!: true, list_update: list_update }

          before do
            expect(controller).to receive(:ensure_authenticated_user){ true }
          end

          it 'returns 200' do
            allow(controller).to receive(:find_scraper){ scraper }
            allow(Interactions::Scraper).to receive(:new){ interactor }
            post :create, params: { list_update: { establishment_id: 1 } }, format: :json
            expect(response.status).to eq 201
          end

          it 'initiates a list update' do
            expect(controller).to receive(:find_scraper){ scraper }
            expect(Interactions::Scraper).to receive(:new).with(scraper){ interactor }
            post :create, params: { list_update: { establishment_id: 1 } }, format: :json
            expect(interactor).to have_received :scrape!
          end
        end
      end
    end
  end
end
