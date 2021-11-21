require "net/http"
require "json"

class QiitaApi
  PER_PAGE = 100
  ACCESS_TOKEN = "e0dc35c3abe4a57cd20f1216b3365e59f794038f".freeze
  GET_ITEMS_URI = "https://qiita.com/api/v2/items".freeze

  # query = 'created:>=2019-04-01 created:<=2019-04-01'
  #  status, next_page, items = QiitaApi.search(query)
  # def self.search(query, page: 1)
  #   # リクエスト情報を作成
  #   uri = URI.parse(GET_ITEMS_URI)
  #   uri.query = URI.encode_www_form({ query: query, per_page: PER_PAGE, page: page })
  #   req = Net::HTTP::Get.new(uri.request_uri)
  #   req["Authorization"] = "Bearer #{ACCESS_TOKEN}"

  #   # リクエスト送信
  #   http = Net::HTTP.new(uri.host, uri.port)
  #   http.use_ssl = true
  #   res = http.request(req)

  #   # 次ページを計算 (API仕様 上限は100ページ)
  #   total_page = ((res["total-count"].to_i - 1) / PER_PAGE) + 1
  #   total_page = (total_page > 100) ? 100 : total_page
  #   next_page = (page < total_page) ? page + 1 : nil

  #   # 返却 [HTTPステータスコード, 次ページ, 記事情報の配列]
  #   return res.code.to_i, next_page, JSON.parse(res.body)
  # end
end
