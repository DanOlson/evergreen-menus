class PlansController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index
    @plan_1 = Plan.tier_1
    @plan_2 = Plan.tier_2
    @plan_3 = Plan.tier_3
    @stripe_pub_key = ENV.fetch('STRIPE_PUB_KEY') {
      APP_CONFIG.dig(:stripe, :pub_key)
    }
  end
end
