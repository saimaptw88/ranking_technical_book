require "amazon/ecs"

# ¥500 = 1 TPD(Transaction per day), ¥432,000 = 1 TPS(Transaction per seccond)
# https://webservices.amazon.com/paapi5/documentation/troubleshooting/api-rates.html
class Batch::AmazonEcsApi
  def self.execute
    # 　デバックログ出力するために記述
    Amazon::Ecs.debug = true

    client = Paapi::Client.new(market: :jp)
    ReccomendedBook.find_each do |book|
      # Amazon::Ecs::Responceオブジェクトの取得
      # res = client.search_items(
      client.search_items(
        keyword: book.title,
        search_index: "Books",
        dataType: "script",
        response_group: "ItemAttributes, Images",
        country: "jp",
        # power: "Not kindle"
      )
      # affiliate_item = book.amazon_affiliates

      # 本のタイトル,画像URL, 詳細ページURLの取得

      # 作成中：売上 0 だと検索できないため中断
      # res.items.each do |item|
      #   affiliate_item.affiliate_url = item.get()
      #   affiliate_item.author
      #   affiliate_item.explanation
      #   affiliate_item.thumbnail_url
      #   affiliate_item.published_date

      #   affiliate_item.save!
      # end
    end
  end
end
