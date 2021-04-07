require 'twilio-ruby'
Twilio.configure do |config|
  config.account_sid = Rails.application.credentials.twilio[:TWILIO_ACCOUNT_SID]
  config.auth_token = Rails.application.credentials.twilio[:TWILIO_AUTH_TOKEN]
end