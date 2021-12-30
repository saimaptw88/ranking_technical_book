class V1::HomeController < ApplicationController
  def show
    id = params[:id]
    book = ReccomendedBook.find(id)

    render json: book, serializer: V1::HomeArticleSerializer
  end
end
