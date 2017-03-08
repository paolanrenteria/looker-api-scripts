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

users = sdk.users()

for each user in users
