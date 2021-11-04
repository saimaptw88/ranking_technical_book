FactoryBot.define do
  factory :reccomended_book do
    article_count { Faker::Number.number(digits: 2) }

    trait :with_qiita_article do
      after(:create) {|i| create(:qiita_article, reccomended_book: i) }
    end

    trait :with_qiita_tag do
      after(:create) {|i| create(:qiita_tag, reccomended_book: i) }
    end
  end
end
