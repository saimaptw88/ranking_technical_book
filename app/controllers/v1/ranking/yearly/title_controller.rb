class V1::Ranking::Yearly::TitleController < ApplicationController
  def index
    titles = []

    5.times do |i|
      id = Redis.current.get("yearly_ranking_#{i + 1}").to_s
      titles << ReccomendedBook.find(id).title
    end

    render json: titles
  end
end
