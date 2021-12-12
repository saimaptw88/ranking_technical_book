class QiitaArticle
  include Mongoid::Document
  field :title, type: String
  field :lgtm_count, type: Integer, default: 0
  field :published_at, type: Time

  index({ title: 1 }, { unique: true })

  validates :title, presence: true
  validates :lgtm_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :published_at, presence: true

  belongs_to :reccomended_book

  def published_at_this_month?
    self.published_at > Time.current.prev_month
  end

  def published_at_this_year?
    self.published_at > Time.current.prev_year
  end

  def published_before_this_year?
    !self.published_at_this_year?
  end
end
