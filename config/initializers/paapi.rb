Paapi.configure do |config|
  config.access_key =  ENV["AMAZON_ACCESS_KEY"]
  config.secret_key =  ENV["AMAZON_SECRET_KEY"]
  config.partner_tag = ENV["AMAZON_PARTNER_TAG"]
end
