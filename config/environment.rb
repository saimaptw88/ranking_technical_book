# Load the Rails application.
require_relative "application"
require "amazon/ecs"

# Initialize the Rails application.
Rails.application.initialize!

Amazon::Ecs.options = {
  associate_tag: ENV["AMAZON_PARTNER_TAG"],
  AWS_access_key_id: ENV["AMAZON_ACCESS_KEY"],
  AWS_secret_key: ENV["AMAZON_SECRET_KEY"],
}
