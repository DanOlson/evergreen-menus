class PlansController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index
    @plans = Plan.active
    @stripe_pub_key = ENV.fetch('STRIPE_PUB_KEY') {
      APP_CONFIG.dig(:stripe, :pub_key)
    }
  end
end
