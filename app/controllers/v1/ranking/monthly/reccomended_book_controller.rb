class V1::Ranking::Monthly::ReccomendedBookController < ApplicationController
  def index
    books = []

    5.times do |i|
      id = Redis.current.get("monthly_ranking_#{i + 1}")
      books << ReccomendedBook.find(id)
    end

    render json: books, each_serializer: V1::HomeSerializer
  end
end
