class V1::HomeSerializer < ActiveModel::Serializer
  attributes :id, :title, :publication_data, :author, :explanation, :thumbnail_url, :total_point, :yearly_point, :monthly_point, :total_ranking,
             :yearly_ranking, :monthly_ranking

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
end
