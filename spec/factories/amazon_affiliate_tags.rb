FactoryBot.define do
  factory :amazon_affiliate_tag do
    tag { Faker::Computer.platform }
  end
end
