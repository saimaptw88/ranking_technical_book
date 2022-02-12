class V1::HomeArticleSerializer < ActiveModel::Serializer
  attributes :id, :title, :publication_data, :author,
             :explanation, :thumbnail_url, :affiliate_url,
             :qiita_titles, :qiita_lgtm, :qiita_tags, :qiita_tag_titles,
             :qiita_tag_count, :total_ranking, :yearly_ranking, :monthly_ranking

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
    object.qiita_articles.map(&:title).first(100)
  end

  def qiita_lgtm
    object.qiita_articles.pluck(:lgtm_count).sum
  end

  def qiita_tags
    object.qiita_tags
  end

  def qiita_tag_titles
    object.qiita_tags.pluck(:kind)
  end

  def qiita_tag_count
    object.qiita_tags.pluck(:kind_count)
  end
end
