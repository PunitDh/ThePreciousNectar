# Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)
Stripe.api_key = ENV["STRIPE_API_KEY"]