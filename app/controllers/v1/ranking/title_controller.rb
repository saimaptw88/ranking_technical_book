class V1::Ranking::TitleController < ApplicationController
  def index
    titles = []

    5.times do |i|
      id = Redis.current.get("total_ranking_#{i+1}").to_s
      titles << ReccomendedBook.find(id).title
    end

    render json: titles
  end
end
