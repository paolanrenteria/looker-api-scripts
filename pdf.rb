require 'looker-sdk'
require 'open-uri'

# Define IDs, secrets, and endpoints for Looker and AWS APIs
credentials = {
  :looker_id => ENV['LOOKER_ID'],
  :looker_secret => ENV['LOOKER_SECRET'],
  :s3_bucket => ENV['S3_BUCKET'],
  :aws_id => ENV['AWS_ACCESS_KEY_ID'],
  :aws_secret => ENV['AWS_ACCESS_KEY_SECRET'],
  :aws_region => ENV['AWS_REGION']
}

# Define the Looker client
sdk = LookerSDK::Client.new(
  :client_id => credentials[:looker_client_id],
  :client_secret => credentials[:looker_client_secret],
  :api_endpoint => 'https://learn.looker.com:19999/api/3.0'
)

# Look ID that lists brand names to iterate over
brand_look = 2334

# Get the list of brand names to create dashboard PDFs for
brand_names = sdk.run_look(brand_look, 'json', options = {:limit => -1})

# 1) For each brand name in the list
brand_names.each do |brand|
  brand_name = brand[:"products.brand_name"]
  # 2) Check to make sure it isn't null or empty
  next if brand_name.nil? || brand_name.empty?
  # 3) Make a folder for it in the bucket
  file_path = 'S3://' + credentials[:s3_bucket_address] + "/#{brand_name}/"
  # 4) Build a scheduled plan to run the dashboard and render a PDF
  plan = {
    :dashboard_id => 314,
    # a) Override the default filter and substitute the current brand name
    :dashboard_filters => URI::encode("?brand=#{brand_name}"),
    # b) Point the schedule to my S3 bucket
    :scheduled_plan_destination => [{
        :format => 'wysiwyg_pdf',
        :address => "#{file_path}", # this is the folder I want it to go in
        :type => 's3',
        # c) Pass the access key, secret key, and region to authenticate to the S3
        :parameters => {:access_key_id => credentials[:s3_access_key_id], :region => credentials[:s3_region]}.to_json,
        :secret_parameters => {:secret_access_key => credentials[:s3_access_key_secret]}.to_json
    }]
  }.to_json # make sure to convert it from a Ruby hash to JSON
  # 5) Run the scheduled plan once (the plan will not run later)
  sdk.scheduled_plan_run_once(plan)
end
