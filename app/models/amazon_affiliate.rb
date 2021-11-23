class AmazonAffiliate
  include Mongoid::Document
  field :affiliate_url, type: String
  field :author, type: String
  field :explanation, type: String
  field :thumbnail_url, type: String
  field :thumbnail_url_small, type: String
  field :publication_data, type: String

  belongs_to :reccomended_book
  embeds_many :amazon_affiliate_tags
end
