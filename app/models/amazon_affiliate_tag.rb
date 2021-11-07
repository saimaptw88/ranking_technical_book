class AmazonAffiliateTag
  include Mongoid::Document
  field :tag, type: String

  embedded_in :amazon_affiliate
end
