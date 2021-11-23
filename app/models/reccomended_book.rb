class ReccomendedBook
  include Mongoid::Document
  include Mongoid::Timestamps

  # フィールド
  field :title, type: String
  field :isbn, type: Integer
  field :point_until_last_year, type: Integer, default: 0
  field :yearly_point, type: Integer, default: 0
  field :monthly_point, type: Integer, default: 0
  field :total_ranking, type: Integer
  field :yearly_ranking, type: Integer
  field :monthly_ranking, type: Integer

  # インデックス
  index({ isbn: 1 }, { unique: true })
  index({ total_ranking: 1 }, { unique: true })
  index({ yearly_ranking: 1 }, { unique: true })
  index({ monthly_ranking: 1 }, { unique: true })

  # バリデーション
  validates :title, presence: true
  validates :isbn, presence: true
  validates :point_until_last_year, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :yearly_point, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :monthly_point, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :total_ranking, uniqueness: { scope: [:reccomend_book_id] }, if: -> { total_ranking.present? }
  validates :yearly_ranking, uniqueness: { scope: [:reccomend_book_id] }, if: -> { yearly_ranking.present? }
  validates :monthly_ranking, uniqueness: { scope: [:reccomend_book_id] }, if: -> { monthly_ranking.present? }

  # アソシエーション
  # rubocop:disable Rails/HasAndBelongsToMany
  has_and_belongs_to_many :qiita_articles, inverse_of: nil
  # rubocop:enable Rails/HasAndBelongsToMany
  embeds_many :qiita_tags
  has_one :amazon_affiliate, dependent: :destroy

  def article_count
    self.qiita_articles.count
  end
end
