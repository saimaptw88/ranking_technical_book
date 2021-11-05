FactoryBot.define do
  factory :reccomended_book do
    title { Faker::Company.name }

    trait :with_qiita_article do
      after(:create) {|i| create(:qiita_article, reccomended_book: i) }
    end

    trait :with_qiita_tag do
      after(:create) {|i| create(:qiita_tag, reccomended_book: i) }
    end
  end
end
