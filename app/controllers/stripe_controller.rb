class StripeController < ApplicationController
  skip_before_action :authenticate_user!, :verify_authenticity_token

  def events
    event = Stripe::Webhook.construct_event(
      request.body.read, signature, webhook_secret
    )
    head :ok
  rescue JSON::ParserError, Stripe::SignatureVerificationError => e
    logger.error "Webhook error: #{e.message}"
    head :bad_request
  end

  private

  def signature
    request.headers['HTTP_STRIPE_SIGNATURE']
  end

  def webhook_secret
    ENV.fetch('STRIPE_WEBHOOK_SECRET') {
      APP_CONFIG.dig(:stripe, :webhook_secret)
    }
  end
end
