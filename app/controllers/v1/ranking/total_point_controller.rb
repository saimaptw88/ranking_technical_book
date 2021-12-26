class V1::Ranking::TotalPointController < ApplicationController
  def index
    i = 0
    total_points = []
    ReccomendedBook.each do |book|
      total_points << book.total_point if i < 5
      i += 1
    end

    render json: total_points
  end
end
