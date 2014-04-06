require 'spec_helper'

module Api
  module V1
    describe SessionsController do
      describe 'POST to #create' do
        context 'with a valid user_id' do
          let(:user){ stub_model User, authenticate: true }
          let(:token){ SecureRandom.hex }
          let(:api_key){ stub_model ApiKey, access_token: token, user_id: user.id }

          before do
            allow(User).to receive(:find_by_id){ user }
            expect(controller).to receive(:create_api_key){ api_key }
            post :create, user_id: user.id, format: :json
          end

          it 'returns an api_key' do
            expected = {
              api_key: {
                user_id: user.id,
                access_token: token
              }
            }.to_json
            expect(response.body).to eq expected
          end

          it 'returns 201' do
            expect(response.status).to eq 201
          end
        end

        context 'with an invalid user_id' do
          before do
            allow(User).to receive(:find_by_id)
            post :create, user_id: 1, format: :json
          end

          it 'returns 401' do
            expect(response.status).to eq 401
          end
        end
      end
    end
  end
end
