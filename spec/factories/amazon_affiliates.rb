FactoryBot.define do
  factory :amazon_affiliate do
    affiliate_url { Faker::Internet.url(host: "example.com") }
    author { Faker::Name.name }
    explanation { Faker::Lorem.sentence(word_count: 10) }
    thumbnail_url { Faker::Internet.url(host: "example.com") }
    publication_data { 30.day.ago }
  end
end
