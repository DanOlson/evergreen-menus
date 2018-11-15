require 'spec_helper'

describe 'subscriptions' do
  describe 'GET to /plans' do
    before do
      create :plan, :tier_1
      create :plan, :tier_2
      create :plan, :tier_3
      get plans_path
    end

    it 'returns 200' do
      expect(response).to have_http_status :ok
    end
  end

  describe 'POST to /subscriptions', :vcr do
    let!(:plan) { create :plan }

    it 'creates a subscription' do
      post subscriptions_path, params: {
        subscription: {
          plan_id: plan.id,
          quantity: 2,
          email: 'walter@lebowski.me',
          source: 'tok_1CwL4DFuGCUWqFqFtVBg8u1P'
        }
      }

      expect(response).to have_http_status :redirect
      expect(response.location).to match /\.com\/register\/.*$/
      expect(Subscription.last.plan).to eq plan

      follow_redirect!
      expect(response).to have_http_status :ok
      expect(response.body).to include 'Signup successful! Please fill in your account details.'
      expect(response.body).to include 'Welcome'
    end

    context 'when creating the subscription is unsuccessful' do
      it 'redirects to /plans' do
        post subscriptions_path, params: {
          subscription: {
            plan_id: plan.id,
            quantity: 2,
            email: 'walter@lebowski.me',
            source: 'tok_1CwL4DFuGCUWqFqFtVBg8u1P' # duplicate token
          }
        }

        expect(response).to redirect_to plans_path
        follow_redirect!
        expect(response.body).to include "Uh oh! We couldn&#39;t sign you up. Please try again."
      end
    end
  end
end
