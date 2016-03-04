require 'spec_helper'

module Api
  module V1
    describe UsersController do
      describe 'GET to #show' do
        let(:user) do
          User.new({
            id: 1,
            username: 'dude',
            first_name: 'Dude',
            last_name: 'Lebowski'
          })
        end

        context 'when the user is found' do
          before do
            expect(User).to receive(:find){ user }
            allow(controller).to receive(:ensure_authenticated_user){ true }
          end

          it 'returns 200' do
            get :show, id: user.id, format: :json
            expect(response.status).to eq 200
          end

          it 'returns the expected JSON' do
            expected = {
              user: {
                id: user.id,
                username: user.username,
                first_name: user.first_name,
                last_name: user.last_name
              }
            }.to_json
            get :show, id: user.id, format: :json
            expect(response.body).to eq expected
          end
        end

        context "when the user is not authenticated" do
          it 'returns 401' do
            get :show, id: 100, format: :json
            expect(response.status).to eq 401
          end
        end
      end
    end
  end
end
