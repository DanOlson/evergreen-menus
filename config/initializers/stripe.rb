Stripe.api_key = ENV.fetch('STRIPE_API_KEY') {
  APP_CONFIG.dig(:stripe, :api_key)
}
