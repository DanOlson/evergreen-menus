class SubscriptionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]

  def new
    @plans = Plan.active
    @stripe_pub_key = ENV.fetch('STRIPE_PUB_KEY') {
      APP_CONFIG.dig(:stripe, :pub_key)
    }
  end

  def create
    redirect_to new_user_registration_path
  end

  private

  def subscription_params
    params.require(:subscription).permit(:plan_id, :email, :source)
  end
end
