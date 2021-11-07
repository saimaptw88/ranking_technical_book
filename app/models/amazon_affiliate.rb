class AmazonAffiliate
  include Mongoid::Document
  field :affiliate_url, type: String
  field :author, type: String
  field :explanation, type: String
  field :thumbnail_url, type: String
  field :publication_data, type: Time

  belongs_to :reccomended_book
end
