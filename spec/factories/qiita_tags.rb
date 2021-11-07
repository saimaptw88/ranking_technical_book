FactoryBot.define do
  factory :qiita_tag do
    kind { Faker::Computer.platform }
    kind_count { Faker::Number.number(digits: 3) }

    reccomended_book
  end
end
