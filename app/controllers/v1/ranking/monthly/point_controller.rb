class V1::Ranking::Monthly::PointController < ApplicationController
  def index
    points = []

    5.times do |i|
      id = Redis.current.get("monthly_ranking_#{i + 1}").to_s
      points << ReccomendedBook.find(id).monthly_point
    end

    render json: points
  end
end
