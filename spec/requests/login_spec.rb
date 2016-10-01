require 'spec_helper'

describe 'session management', type: :request do
  context 'via the API' do
    let!(:user) do
      User.create!({
        username: 'thedude',
        email: 'dude@lebowski.me',
        password: 'abide'
      })
    end

    before do
      post '/api/v1/sessions', {
        params: {
          username: 'thedude',
          password: password
        },
        headers: {
          accept: 'application/json'
        }
      }
    end

    context 'successful authentication' do
      let(:password) { 'abide' }

      it 'returns 201' do
        expect(response.status).to eq 201
      end

      it 'returns an api_key' do
        parsed_response = JSON.parse response.body
        expect(parsed_response).to have_key 'api_key'
        expect(parsed_response['api_key']['user_id']).to eq user.id
        expect(parsed_response['api_key']['access_token']).to_not be_empty
      end
    end

    context 'unsuccessful authentication' do
      let(:password) { 'passwrod' }

      it 'returns 401' do
        expect(response.status).to eq 401
      end
    end
  end
end
