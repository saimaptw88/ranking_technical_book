class V1::Ranking::TotalPointController < ApplicationController
  def index
    total_points = []

    5.times do |i|
      id = Redis.current.get("total_ranking_#{i + 1}").to_s
      total_points << ReccomendedBook.find(id).total_point
    end

    render json: total_points
  end
end
