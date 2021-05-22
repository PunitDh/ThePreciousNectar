# Rails.application.config.middleware.use OmniAuth::Builder do
#     provider :google_oauth2, Rails.application.credentials.dig(:google, :google_client_id), Rails.application.credentials.dig(:google, :google_client_secret)
#   end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET']
end
OmniAuth.config.allowed_request_methods = %i[get]

# Rails.application.config.middleware.use OmniAuth::Builder do
#   provider :facebook, ENV['FACEBOOK_CLIENT_ID'], ENV['FACEBOOK_CLIENT_SECRET']
# end