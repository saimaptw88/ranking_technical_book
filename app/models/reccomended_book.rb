class ReccomendedBook
  include Mongoid::Document
  # フィールド
  field :title, type: String
  # バリデーション
  validates :title, presence: true
  # アソシエーション
  has_many :qiita_articles, dependent: :destroy
  has_many :qiita_tags, dependent: :destroy

  def article_count
    self.qiita_articles.count
  end
end
