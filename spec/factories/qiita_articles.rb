FactoryBot.define do
  factory :qiita_article do
    title { Faker::Company.name }
    lgtm_count { Faker::Number.number(digits: 3) }
    created_at { 30.day.ago }

    reccomended_book
  end
end
