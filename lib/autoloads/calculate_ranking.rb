class CalculateRanking
  # command bundle exec rails runner CalculateRanking.execute
  def self.execute
    terms = ["total", "yearly", "monthly"]

    terms.each do |term|
      CalculateRanking.update_point(term: term)
      CalculateRanking.update_ranking(term: term)
    end
  end

  # 各書籍のポイントを計算
  # ポイント計算のロジック
  #   新規性が高い　　：直近1ヶ月の記事で紹介されていること   ： 100 * ( 直近1ヶ月の記事数  + その他の記事数 )
  #   評価が高い　　　：LGTM が多い　　　　　　　　　　　    ： LGTM数
  #   初学者向けである：タグに「初学者」「初心者」が含まれる　 ： 1000 * ( 初学者タグ数 + 初心者タグ数 )
  # command bundle exec rails runner CalculateRanking.update_point
  def self.update_point(term:)
    field = (term + "_point").to_sym

    ReccomendedBook.each do |book|
      article_count, recently_article_count, lgtm_count, beginner_count = CalculateRanking.calculate_term_point_elements(reccomended_book: book, term: term)
      point = if term != "monthly"
                100 * (article_count + recently_article_count) + lgtm_count + 1000 * beginner_count
              else
                100 * article_count + lgtm_count + 1000 * beginner_count
              end

      book.update!(field => point)
    end
  end

  # ranking を更新する
  # NOTE : term: 引数は : "total", "yearly", "monthly"
  # command bundle exec rails runner CalculateRanking.update_ranking(term: "total")
  def self.update_ranking(term:)
    i = 1
    point_kind = (term + "_point").to_sym
    ranking_kind = (term + "_ranking").to_sym

    # NOTE : .order メソッドが使えないため sort_by
    ids_and_points = ReccomendedBook.pluck(:id, point_kind).sort_by{|k,v| v}.reverse
    ids_and_points.each do |id_and_point|
      book = ReccomendedBook.find(id_and_point[0])
      book.update(ranking_kind => i)
      i += 1
    end
  end

  # NOTE : term 引数は : "total", "yearly", "monthly"
  def self.calculate_term_point_elements(reccomended_book:, term:)
    return 0, 0, 0, 0 if reccomended_book.qiita_articles.blank?

    articles = CalculateRanking.set_articles(reccomended_book: reccomended_book, term: term)

    recently_article_count = CalculateRanking.recently_article_count(articles_id: articles.pluck(:id))

    article_count = articles.count

    lgtm_count = articles.pluck(:lgtm_count).sum

    beginner_count = CalculateRanking.beginner_count(reccomended_book: reccomended_book)

    return article_count, recently_article_count, lgtm_count, beginner_count
  end

  def self.set_articles(reccomended_book:, term:)
    articles = []
    # NOTE : mongoid は where("xx > ?", yy) の書き方ができない
    reccomended_book.qiita_articles.each do |article|
      articles << article if term == "total"
      articles << article if term == "yearly" && article.published_at_this_year?
      articles << article if term == "monthly" && article.published_at_this_month?
    end

    articles
  end

  def self.recently_article_count(articles_id:)
    articles = QiitaArticle.where(id: articles_id)

    # NOTE : mongoid は where("xx > ?", yy) の書き方ができない
    recently_article_count = 0
    articles.each do |article|
      recently_article_count += 1 if article.published_at_this_month?
    end

    recently_article_count
  end

  def self.beginner_count(reccomended_book:)
    return 0 if reccomended_book.qiita_tags.blank?

    beginner_count = 0
    reccomended_book.qiita_tags.each do |tag|
      beginner_count += 1 if tag.kind.include?("初学者") || tag.kind.include?("初心者") || tag.kind.include?("新人")
    end

    beginner_count
  end
end
