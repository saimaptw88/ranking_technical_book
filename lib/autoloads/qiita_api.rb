require "net/http"
require "json"

class QiitaApi
  # 記事を取得
  # 取得した記事に技術書が含まれているかを確認
  # 技術書が含まれていたらレコードを作成 or 更新

  PER_PAGE = 100
  ACCESS_TOKEN = ENV["QIITA_ACCESS_TOKEN"].freeze
  GET_ITEMS_URI = "https://qiita.com/api/v2/items".freeze

  # command bundle exec rails runner QiitaApi.execute
  def self.execute
    query = "created:>=2021-11-30 created:<=2021-11-30"
    next_page = 1

    100.times do
      _status, next_page, items = QiitaApi.search_article(query, page: next_page)

      break if next_page == -1

      items.each do |item|
        QiitaApi.include_technical_book?(item: item)
      end
    end
  end

  # command bundle exec rails runner QiitaApi.destroy_all
  def self.destroy_all
    QiitaArticle.each(&:destroy!)
  end

  # 記事取得
  def self.search_article(query, page:)
    # リクエスト情報を作成
    uri = URI.parse(GET_ITEMS_URI)
    uri.query = URI.encode_www_form({ query: query, per_page: PER_PAGE, page: page })
    req = Net::HTTP::Get.new(uri.request_uri)
    req["Authorization"] = "Bearer #{ACCESS_TOKEN}"

    # リクエスト送信
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    res = http.request(req)

    # 次ページを計算 (API仕様 上限は100ページ)
    total_page = ((res["total-count"].to_i - 1) / PER_PAGE) + 1
    total_page = (total_page > 100) ? 100 : total_page
    next_page = (page < total_page) ? page + 1 : nil

    # 返却 [HTTPステータスコード, 次ページ, 記事情報の配列]
    return res.code.to_i, next_page, JSON.parse(res.body)
  end

  # 記事に技術書が含まれているか確認
  def self.include_technical_book?(item:)
    ReccomendedBook.each do |book|
      next unless item["rendered_body"].include?(book.title) || item["title"].include?(book.title)

      book.qiita_articles.create!(title: item["title"], lgtm_count: item["likes_count"], created_at: item["created_at"])

      # Qiita のタグが同一記事内で重複しないことが前提
      book_tags = book.qiita_tags.pluck(:kind)

      item["tags"].each do |tag|
        if book_tags.include?(tag["name"])
          qiita_tag = book.qiita_tags.find_by(kind: tag["name"])
          qiita_tag.kind_count += 1
          qiita_tag.save!
        else
          book.qiita_tags.create!(kind: tag["name"], kind_count: 1)
        end
      end
    end
  end
end
