class V1::Ranking::TitleSerializer < ActiveModel::Serializer
  attributes :id, :title
  def title
    binding.pry
  end
end
