require 'spec_helper'

describe StripeSubscription do
  before do
    Timecop.freeze Time.at 1532398535 # 2018-07-23 21:15:35 -0500
  end

  after do
    Timecop.return
  end

  describe '.create', :vcr do
    let(:plan) { create :plan, remote_id: 'restauranteur-development' }
    let(:customer) { double StripeCustomer, id: 'cus_DHqGf2aCq0nWUt' }

    it 'creates a StripeSubscription' do
      three_weeks_from_now = (Time.now + 3.weeks).to_i
      subscription = StripeSubscription.create customer: customer, plan: plan

      expect(subscription).to be_a StripeSubscription
      expect(subscription.id).to start_with 'sub_'
      expect(subscription.object).to eq 'subscription'
      expect(subscription.customer).to eq 'cus_DHqGf2aCq0nWUt'
      expect(subscription.status).to eq 'trialing'
      expect(subscription.trial_end).to eq 1534212935
      expect(subscription.plan.id).to eq 'restauranteur-development'
    end
  end

  describe '.calculate_end_date' do
    context 'when the plan has a monthly interval' do
      let(:plan) { build_stubbed :plan, interval: :month }

      it 'returns a date based on the interval of the given plan' do
        end_date = StripeSubscription.calculate_end_date plan: plan
        expect(end_date).to eq Date.parse('2018-08-23')
      end
    end

    context 'when the plan has a quarterly interval' do
      let(:plan) { build_stubbed :plan, interval: :month, interval_count: 3 }

      it 'returns a date based on the interval of the given plan' do
        end_date = StripeSubscription.calculate_end_date plan: plan
        expect(end_date).to eq Date.parse('2018-10-23')
      end
    end

    context 'when given a from_date' do
      let(:plan) { build_stubbed :plan, interval: :month }

      it 'returns the date calculated from the provided date' do
        date = Date.parse('2018-06-14')
        end_date = StripeSubscription.calculate_end_date plan: plan, from_date: date
        expect(end_date).to eq Date.parse('2018-07-14')
      end
    end
  end
end