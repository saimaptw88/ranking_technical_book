class QiitaTag
  include Mongoid::Document

  # field
  field :kind, type: String
  field :kind_count, type: Integer, default: 0

  # index
  # validation
  validates :kind, presence: true
  validates :kind_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # assosiation
  embedded_in :reccomended_book
end
