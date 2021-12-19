class V1::HomeArticleSerializer < ActiveModel::Serializer
  attributes :id, :title, :publication_data, :author, :explanation, :thumbnail_url, :affiliate_url, :qiita_titles, :qiita_lgtm, :qiita_tags

  def publication_data
    object.amazon_affiliate.publication_data
  end

  def author
    object.amazon_affiliate.author
  end

  def explanation
    object.amazon_affiliate.explanation
  end

  def thumbnail_url
    object.amazon_affiliate.thumbnail_url
  end

  def affiliate_url
    object.amazon_affiliate.affiliate_url
  end

  def qiita_titles
    object.qiita_articles.map(&:title)
  end

  def qiita_lgtm
    object.qiita_articles.pluck(:lgtm_count).sum
  end

  def qiita_tags
    object.qiita_tags
  end
end
