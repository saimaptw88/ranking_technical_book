FactoryBot.define do
  factory :reccomended_book do
    title { Faker::Company.name }
    isbn { Faker::Number.number(digits: 13) }
    point_until_last_year { Faker::Number.number(digits: 3) }
    yearly_point { Faker::Number.number(digits: 3) }
    monthly_point { Faker::Number.number(digits: 3) }

    sequence(:total_ranking) {|n| n }
    sequence(:yearly_ranking) {|n| n }
    sequence(:monthly_ranking) {|n| n }

    # amazon_affiliate

    # trait :with_amazon_affiliate do
    #   after(:create) do |i|
    #     i.amazon_affiliate.new(
    #       affiliate_url: Faker::Internet.url(host: "example.com"),
    #       author: Faker::Name.name,
    #       explanation: Faker::Lorem.sentence(word_count: 10),
    #       thumbnail_url: Faker::Internet.url(host: "example.com"),
    #       publication_data: 30.day.ago,
    #     )
    #   end
    # end

    trait :with_qiita_article do
      after(:create) do |i|
        i.qiita_articles.create(
          title: Faker::Company.name.to_s,
          lgtm_count: Faker::Number.number(digits: 3),
          created_at: 30.day.ago,
        )
      end
    end

    trait :with_qiita_tag do
      after(:create) {|i| create(:qiita_tag, reccomended_book: i) }
    end
  end
end
