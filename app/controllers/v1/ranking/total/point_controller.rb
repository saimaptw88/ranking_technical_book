class V1::Ranking::Total::PointController < ApplicationController
  def index
    points = []

    5.times do |i|
      id = Redis.current.get("total_ranking_#{i + 1}").to_s
      points << ReccomendedBook.find(id).total_point
    end

    render json: points
  end
end
