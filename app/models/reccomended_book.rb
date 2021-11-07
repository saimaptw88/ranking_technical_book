class ReccomendedBook
  include Mongoid::Document
  # フィールド
  field :title, type: String
  # バリデーション
  validates :title, presence: true
  # アソシエーション
  has_and_belongs_to_many :qiita_articles, inverse_of: nil
  embeds_many :qiita_tags

  def article_count
    self.qiita_articles.count
  end
end
