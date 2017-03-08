require 'looker-sdk'
require 'open-uri'

# Get client ID and client secret from environmental variables
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

# Define the search-term (this should be input by the user)
field_search = 'age_tier'

# Get all Looks
look_queries = sdk.all_looks(:fields => 'id, query_id')

# Empty array to fill with Look IDs
field_matches = []

# Iterate over every look (this might take a while)
for look_query in look_queries
  # Get the fields for that Look using the query ID
  fields = sdk.query(look_query.to_h[:query_id], {:fields => 'fields'}).to_h[:fields]
  # If any of the fields match the field search term, add that Look ID to field_matches
  if fields.any? {|field| field.match(field_search)}
    field_matches.push(look_query.to_h[:id])
  end
end

# Print results to console
puts field_matches
