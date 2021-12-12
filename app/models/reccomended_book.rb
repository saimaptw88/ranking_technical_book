class ReccomendedBook
  include Mongoid::Document
  include Mongoid::Timestamps

  # フィールド
  field :title, type: String
  field :isbn, type: Integer
  field :total_point, type: Integer, default: 0
  field :yearly_point, type: Integer, default: 0
  field :monthly_point, type: Integer, default: 0
  field :total_ranking, type: Integer
  field :yearly_ranking, type: Integer
  field :monthly_ranking, type: Integer

  # インデックス
  index({ title: 1 }, { unique: true })
  index({ total_ranking: 1 }, { unique: true })
  index({ yearly_ranking: 1 }, { unique: true })
  index({ monthly_ranking: 1 }, { unique: true })

  # バリデーション
  validates :title, presence: true, uniqueness: true, length: { minimum: 6 }
  validates :total_point, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :yearly_point, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :monthly_point, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # アソシエーション
  has_many :qiita_articles, dependent: :destroy
  embeds_many :qiita_tags
  has_one :amazon_affiliate, dependent: :destroy

  def article_count
    self.qiita_articles.count
  end
end
