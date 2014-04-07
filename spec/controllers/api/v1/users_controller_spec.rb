require 'spec_helper'

module Api
  module V1
    describe UsersController do
      describe 'GET to #show' do
        let(:user){ stub_model User }

        before do
          expect(User).to receive(:find){ user }
        end
      end
    end
  end
end
