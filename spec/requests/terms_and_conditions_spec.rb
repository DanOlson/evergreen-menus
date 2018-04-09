require 'spec_helper'

describe 'Terms and Conditions' do
  describe 'GET to /terms' do
    it 'returns successfully' do
      get '/terms'

      expect(response).to have_http_status :ok
      expect(response.body).to match /Terms and Conditions/
    end
  end

  describe 'GET to /privacy' do
    it 'returns successfully' do
      get '/privacy'

      expect(response).to have_http_status :ok
      expect(response.body).to match /Privacy Policy/
    end
  end
end
