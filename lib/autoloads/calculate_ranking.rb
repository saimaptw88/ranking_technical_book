class CalculateRanking
  # command bundle exec rails runner CalculateRanking.execute
  def self.execute
    CalculateRanking.update_each_point

    i = 1
    ReccomendedBook.all.order(total_point: :asc).each do |book|
      book.update!(total_ranking: i)
      i += 1
    end

    i = 1
    ReccomendedBook.all.order(yearly_point: :asc).each do |book|
      book.update!(yearly_ranking: i)
      i += 1
    end

    i = 1
    ReccomendedBook.all.order(monthly_point: :asc).each do |book|
      book.update!(monthly_ranking: i)
      i += 1
    end
  end

  # 各書籍のポイントを計算
  # ポイント計算のロジック
  #   新規性が高い　　：直近1ヶ月の記事で紹介されていること   ： 100 * ( 直近1ヶ月の記事数  + その他の記事数 )
  #   評価が高い　　　：LGTM が多い　　　　　　　　　　　    ： LGTM数
  #   初学者向けである：タグに「初学者」「初心者」が含まれる　 ： 1000 * ( 初学者タグ数 + 初心者タグ数 )
  # command bundle exec rails runner CalculateRanking.update_each_point
  def self.update_each_point
    ReccomendedBook.each do |book|
      # total_point
      article_count, recently_article_count, lgtm_count, beginner_count = CalculateRanking.calculate_term_point_elements(reccomended_book: book,
                                                                                                                         term: "total")
      total_point = 100 * (article_count + recently_article_count) + lgtm_count + 1000 * beginner_count

      # yearly_point
      article_count, recently_article_count, lgtm_count, beginner_count = CalculateRanking.calculate_term_point_elements(reccomended_book: book,
                                                                                                                         term: "yearly")
      yearly_point = 100 * (article_count + recently_article_count) + lgtm_count + 1000 * beginner_count

      # monthly_point
      article_count, _recently_article_count, lgtm_count, beginner_count = CalculateRanking.calculate_term_point_elements(reccomended_book: book,
                                                                                                                          term: "monthly")
      monthly_point = 100 * article_count + lgtm_count + 1000 * beginner_count

      book.update!(total_point: total_point, yearly_point: yearly_point, monthly_point: monthly_point)
    end
  end

  def self.calculate_term_point_elements(reccomended_book:, term:)
    return 0, 0, 0, 0 if reccomended_book.qiita_articles.blank?

    articles = []

    # NOTE : mongoid は where("xx > ?", yy) の書き方ができない
    reccomended_book.qiita_articles.each do |article|
      articles << article if term == "total"
      articles << article if term == "yearly" && article.published_at_this_year?
      articles << article if term == "monthly" && article.published_at_this_month?
    end

    # NOTE : mongoid は where("xx > ?", yy) の書き方ができない
    # recently_article_count = 0
    # articles.each do |article|
    #   recently_article_count += 1 if article.published_at_this_month?
    # end
    recently_article_count = CalculateRanking.recently_article_count(articles_id: articles.pluck(:id))

    article_count = articles.count

    lgtm_count = articles.pluck(:lgtm_count).sum

    beginner_count = CalculateRanking.beginner_count(reccomended_book: reccomended_book)

    return article_count, recently_article_count, lgtm_count, beginner_count
  end

  def self.beginner_count(reccomended_book:)
    return 0 if reccomended_book.qiita_tags.blank?

    beginner_count = 0
    reccomended_book.qiita_tags.each do |tag|
      beginner_count += 1 if tag.kind.include?("初学者") || tag.kind.include?("初心者") || tag.kind.include?("新人")
    end

    beginner_count
  end

  def self.recently_article_count(articles_id:)
    articles = QiitaArticle.where(id: aritcles_id)

    # NOTE : mongoid は where("xx > ?", yy) の書き方ができない
    recently_article_count = 0
    articles.each do |article|
      recently_article_count += 1 if article.published_at_this_month?
    end

    recently_article_count
  end
end
