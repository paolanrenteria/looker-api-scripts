require 'looker-sdk'
require 'open-uri'

# Define IDs, secrets, and endpoints for Looker and AWS APIs
credentials = {
  :looker_id => ENV['LOOKER_ID'],
  :looker_secret => ENV['LOOKER_SECRET']
}

# Define the Looker client
sdk = LookerSDK::Client.new(
  :client_id => credentials[:looker_id],
  :client_secret => credentials[:looker_secret],
  :api_endpoint => 'https://learn.looker.com:19999/api/3.0'
)

old_dash = sdk.dashboard(327).to_h
new_dash = {
  :space_id => old_dash[:space_id],
  :title => 'Test Copy Dashboard'
}.to_json

sdk.create_dashboard(new_dash)
