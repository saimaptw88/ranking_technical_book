class V1::Ranking::Yearly::ReccomendedBookController < ApplicationController
  def index
    # Redis から total_ranking 上位から順に記事を取得する
    books = []

    25.times do |i|
      id = Redis.current.get("yearly_ranking_#{i + 1}")
      books << ReccomendedBook.find(id)
    end

    render json: books, each_serializer: V1::HomeSerializer
  end
end
