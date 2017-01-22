require 'spec_helper'

module Api
  module V1
    describe EstablishmentsController do
      let(:time){ Time.zone.now.iso8601(3) }
      let(:establishment) do
        Establishment.new({
          name: 'Foo',
          address: '123 foo street',
          url: 'http://foo.com/beers',
          active: true,
          latitude: BigDecimal.new('44.978375'),
          longitude: BigDecimal.new('-93.261214'),
          created_at: time,
          updated_at: time,
        })
      end

      describe 'GET to #show' do
        before do
          expect(controller).to receive(:find_establishment){ establishment }
          get :show, params: { id: 1 }, format: :json
        end

        it { expect(response).to be_success }
        it 'returns the expected JSON' do
          json = JSON.parse(response.body)['establishment']
          expect(json['name']).to eq establishment.name
          expect(json['address']).to eq establishment.address
          expect(json['url']).to eq establishment.url
          expect(json['active']).to eq true
          expect(json['latitude']).to eq '44.978375'
          expect(json['longitude']).to eq '-93.261214'
          expect(Time.parse(json['created_at'])).to eq time
          expect(Time.parse(json['updated_at'])).to eq time
        end
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
            patch :update, params: { id: 1 }, format: :json
            expect(response.status).to eq 401
          end
        end

        context 'when authenticated' do
          let(:params) do
            {
              name: 'Foo',
              url: 'http://example.com',
              active: 'false'
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
              strong_params = ActionController::Parameters.new(params).permit(:name, :url, :active)
              expect(establishment).to receive(:update_attributes).with strong_params
              patch :update, params: { id: 1, establishment: params }, format: :json
            end

            it 'returns 204' do
              allow(establishment).to receive :update_attributes
              patch :update, params: { id: 1, establishment: params }, format: :json
              expect(response.status).to eq 204
            end
          end

          context 'failure' do
            let(:params){ super().merge(name: '', url: '') }

            before do
              expect(controller).to receive(:find_establishment){ establishment }
              patch :update, params: { id: 1, establishment: params }, format: :json
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

      describe 'POST to #create' do
        let(:params) do
          {
            name: 'Foo',
            address: '123 Foo St',
            url: 'http://foo.com/beers',
            latitude: BigDecimal.new('44.978375'),
            longitude: BigDecimal.new('-93.261214'),
            active: true
          }
        end

        before do
          patch :create, params: { establishment: params }, format: :json
        end

        context 'when not authenticated' do
          it 'returns 401' do
            expect(response.status).to eq 401
          end
        end

        context 'when authenticated' do
          let(:scraper) do
            double :establishment= => nil, save: nil
          end
          let(:establishment) do
            Establishment.new(
              params.merge({
                created_at: Time.zone.now,
                updated_at: Time.zone.now
              })
            )
          end
          before do
            allow(establishment).to receive(:save)
            allow(controller).to receive(:init_establishment){ establishment }
            allow(Scraper).to receive(:find).with('1'){ scraper }
            expect(controller).to receive(:ensure_authenticated_user){ true }
            post :create, params: { establishment: params.merge(scraper_id: 1) }, format: :json
          end

          context 'with valid parameters' do
            it 'returns 201' do
              expect(response.status).to eq 201
            end

            it 'returns a json representation of the record' do
              json = JSON.parse(response.body)['establishment']
              expect(json['name']).to eq params[:name]
              expect(json['address']).to eq params[:address]
              expect(json['url']).to eq params[:url]
              expect(json['latitude']).to eq params[:latitude].to_s
              expect(json['longitude']).to eq params[:longitude].to_s
              expect(json['active']).to eq params[:active]
              expect(json['created_at']).to_not be_nil
              expect(json['updated_at']).to_not be_nil
              expect(json['beer_ids']).to eq []
            end
          end

          context 'with invalid parameters' do
            let(:params){ super().merge(name: '', url: '') }

            it 'returns 422' do
              expect(response.status).to eq 422
            end

            it 'returns appropriate errors' do
              expected = {
                errors: {
                  name: ["can't be blank"],
                  url: ["can't be blank"]
                }
              }.to_json
              expect(response.body).to eq expected
            end
          end
        end
      end
    end
  end
end
