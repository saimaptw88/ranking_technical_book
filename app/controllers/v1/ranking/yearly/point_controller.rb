class V1::Ranking::Yearly::PointController < ApplicationController
  def index
    points = []

    5.times do |i|
      id = Redis.current.get("yearly_ranking_#{i + 1}").to_s
      points << ReccomendedBook.find(id).yearly_point
    end

    render json: points
  end
end
