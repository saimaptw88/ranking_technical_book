class QiitaArticle
  include Mongoid::Document
  field :title, type: String
  field :lgtm_count, type: Integer, default: 0
  field :created_at, type: Time

  index({ title: 1 }, { unique: true })

  validates :title, presence: true
  validates :lgtm_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :created_at, presence: true

  belongs_to :reccomended_book
end
