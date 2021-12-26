class V1::Ranking::TitleController < ApplicationController
  def index
    i = 0
    titles = []
    ReccomendedBook.each do |book|
      titles << book.title if i < 5
      i += 1
    end

    render json: titles
  end
end
