require "rails_helper"

describe CalculateRanking do
  # 書籍名が登録されている
  # 記事が登録されている
  # ランキングが登録されいてる

  # ポイントの更新
  # 各ランキングを更新
  describe ".execute" do

  end

  # ポイントの更新
  describe ".update_each_point" do

  end


  # 各期間のポイントを更新
  describe ".calculate_term_point_elements(reccomended_book:, term:)" do

  end

  # reccomended_book に紐づく記事を全て取得
  describe ".set_articles(reccomended_book:, term:)" do

  end

  # 直近1ヶ月の記事数を取得する
  describe ".recently_article_count(articles_id:)" do

  end

  # ポイント計算の1要素の初学者タグがあるか確認する
  describe ".beginner_count(reccomended_book:)" do

  end
end
