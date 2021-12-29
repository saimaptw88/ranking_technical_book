class V1::HomeController < ApplicationController
  def index
    # Redis から total_ranking 上位から順に記事を取得する
    books = []

    5.times do |i|
      id = Redis.current.get("total_ranking_#{i + 1}")
      books << ReccomendedBook.find(id)
    end

    render json: books, each_serializer: V1::HomeSerializer
  end

  def show
    id = params[:id]
    book = ReccomendedBook.find(id)

    render json: book, serializer: V1::HomeArticleSerializer
  end
end
