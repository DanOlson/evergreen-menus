class SubscriptionsController < ApplicationController
  skip_before_action :authenticate_user!, only: :create

  def create
    service = SignupService.new({
      plan_id: subscription_params[:plan_id],
      email: subscription_params[:email],
      quantity: subscription_params[:quantity],
      credit_card_token: subscription_params[:source]
    })
    service.call
    if service.success?
      gid = service.signup_invitation.to_sgid for: 'registration'
      redirect_to new_invited_registration_path(gid), notice: 'Signup successful! Please fill in your account details.'
    else
      redirect_to plans_path, alert: "Uh oh! We couldn't sign you up. Please try again."
    end
  end

  private

  def subscription_params
    params.require(:subscription).permit(
      :plan_id,
      :email,
      :source,
      :quantity
    )
  end
end
