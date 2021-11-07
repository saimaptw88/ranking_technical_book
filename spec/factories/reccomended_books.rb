FactoryBot.define do
  factory :reccomended_book do
    title { Faker::Company.name }

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
