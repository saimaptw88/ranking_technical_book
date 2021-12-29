class V1::HomeController < ApplicationController
  def index
    # Redis から total_ranking 上位から順に記事を取得する
    # ids_and_points = ReccomendedBook.pluck(:id, :total_ranking).sort_by {|_k, v| v }.reverse
    # books = ids_and_points.first(5).map {|k, _v| ReccomendedBook.find(k) }

    # i = 0
    books = []

    # ReccomendedBook.each do |book|
    #   books << book if i < 5
    #   i += 1
    # end
    # binding.pry

    5.times do |i|
      id = Redis.current.get("total_ranking_#{i+1}")
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
