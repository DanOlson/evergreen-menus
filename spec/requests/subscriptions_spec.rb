require 'spec_helper'

describe 'subscriptions' do
  describe 'GET to /plans' do
    before do
      get plans_path
    end

    it 'returns 200' do
      expect(response).to have_http_status :ok
    end
  end

  describe 'POST to /subscriptions', :vcr do
    let!(:plan) { create :plan, remote_id: 'restauranteur-development' }

    it 'creates a subscription' do
      post subscriptions_path, params: {
        subscription: {
          plan_id: plan.id,
          email: 'walter@lebowski.me',
          source: 'tok_1CrcRpFuGCUWqFqFWmggUkFo'
        }
      }

      expect(response).to have_http_status :redirect
      expect(Subscription.last.plan).to eq plan
    end

    context 'when creating the subscription is unsuccessful' do
      it 'redirects to /plans' do
        post subscriptions_path, params: {
          subscription: {
            plan_id: plan.id,
            email: 'walter@lebowski.me',
            source: 'tok_1CrcRpFuGCUWqFqFWmggUkFo' # duplicate token
          }
        }

        expect(response).to redirect_to plans_path
        follow_redirect!
        expect(response.body).to include "Uh oh! We couldn&#39;t sign you up. Please try again."
      end
    end
  end
end
